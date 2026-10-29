terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  # Built-in Azure Policy definitions. Using built-ins where they exist keeps the
  # surface we have to maintain small; custom rules live in /policies/definitions.
  builtin = {
    allowed_locations      = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    require_tag            = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
    storage_secure_traffic = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
    nic_no_public_ip       = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
    storage_no_public_net  = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
  }

  # Assignment names on a management group are limited to 24 characters.
  builtin_assignments = merge(
    {
      "allowed-locations" = {
        scope         = "org"
        definition_id = local.builtin.allowed_locations
        display_name  = "Restrict resources to approved regions"
        message       = "Deploy only to approved regions: ${join(", ", var.allowed_locations)}."
        parameters    = { listOfAllowedLocations = { value = var.allowed_locations } }
      }
      "storage-secure-transfer" = {
        scope         = "org"
        definition_id = local.builtin.storage_secure_traffic
        display_name  = "Storage accounts must require secure transfer"
        message       = "Enable 'Secure transfer required' on the storage account."
        parameters    = { effect = { value = "Deny" } }
      }
      "corp-no-public-nic-ip" = {
        scope         = "corp"
        definition_id = local.builtin.nic_no_public_ip
        display_name  = "Corp: network interfaces must not have public IPs"
        message       = "Corp workloads are private. Expose services through the hub firewall or an approved gateway."
        parameters    = {}
      }
      "corp-storage-no-public" = {
        scope         = "corp"
        definition_id = local.builtin.storage_no_public_net
        display_name  = "Corp: storage accounts must disable public network access"
        message       = "Disable public network access and use private endpoints."
        parameters    = { effect = { value = "Deny" } }
      }
    },
    {
      for tag in var.required_tags :
      substr("req-tag-${lower(tag)}", 0, 24) => {
        scope         = "landing_zones"
        definition_id = local.builtin.require_tag
        display_name  = "Require tag '${tag}' on resources"
        message       = "Resources must carry the '${tag}' tag."
        parameters    = { tagName = { value = tag } }
      }
    }
  )
}

# --- Custom definitions (policy-as-code) -------------------------------------
# Drop a JSON file into /policies/definitions and it is created and assigned at
# the organisation scope on the next apply. Shape:
#   { "displayName", "description", "mode", "metadata", "parameters"?, "policyRule" }
locals {
  custom_dir = "${path.module}/../../policies/definitions"
  custom = {
    for f in fileset(local.custom_dir, "*.json") :
    trimsuffix(f, ".json") => jsondecode(file("${local.custom_dir}/${f}"))
  }
}

resource "azurerm_policy_definition" "custom" {
  for_each = local.custom

  name                = each.key
  policy_type         = "Custom"
  mode                = try(each.value.mode, "Indexed")
  display_name        = each.value.displayName
  description         = try(each.value.description, null)
  management_group_id = var.management_group_ids["org"]

  metadata    = try(jsonencode(each.value.metadata), null)
  parameters  = try(jsonencode(each.value.parameters), null)
  policy_rule = jsonencode(each.value.policyRule)
}

# --- Assignments --------------------------------------------------------------
resource "azurerm_management_group_policy_assignment" "builtin" {
  for_each = local.builtin_assignments

  name                 = each.key
  display_name         = each.value.display_name
  management_group_id  = var.management_group_ids[each.value.scope]
  policy_definition_id = each.value.definition_id
  parameters           = length(each.value.parameters) > 0 ? jsonencode(each.value.parameters) : null
  enforce              = var.enforce

  non_compliance_message {
    content = each.value.message
  }
}

resource "azurerm_management_group_policy_assignment" "custom" {
  for_each = local.custom

  name                 = substr(each.key, 0, 24)
  display_name         = each.value.displayName
  management_group_id  = var.management_group_ids["org"]
  policy_definition_id = azurerm_policy_definition.custom[each.key].id
  enforce              = var.enforce

  non_compliance_message {
    content = try(each.value.description, each.value.displayName)
  }
}
