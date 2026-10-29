# Bootstrap: creates what the pipeline itself needs before it can run.
#   1. A hardened storage account + container for Terraform remote state
#   2. Two Entra ID identities trusted by GitHub via OIDC (no client secrets)
#        - plan  : read-only, used on pull requests
#        - apply : can change infrastructure, only from the 'production' environment
#
# Run once, locally, as a user with Owner on the state subscription and
# permission to create app registrations. State for this folder is local on purpose;
# it is small and rarely changes. Commit nothing from .terraform/ or *.tfstate.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id     = var.state_subscription_id
  storage_use_azuread = true # shared keys are disabled on the state account
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

locals {
  repo = "${var.github_org}/${var.github_repo}"

  identities = {
    plan = {
      subjects = ["repo:${local.repo}:pull_request"]
      roles    = ["Reader"]
    }
    apply = {
      subjects = ["repo:${local.repo}:environment:${var.github_environment}"]
      roles = [
        "Contributor",
        "Resource Policy Contributor",
        "Management Group Contributor",
      ]
    }
  }

  federated_credentials = merge([
    for name, id in local.identities : {
      for i, subject in id.subjects : "${name}-${i}" => { identity = name, subject = subject }
    }
  ]...)

  role_assignments = merge([
    for name, id in local.identities : {
      for role in id.roles : "${name}-${role}" => { identity = name, role = role }
    }
  ]...)
}

# --- Remote state -------------------------------------------------------------
resource "azurerm_resource_group" "state" {
  name     = "rg-${var.name_prefix}-tfstate"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "state" {
  name                = var.state_storage_account_name
  resource_group_name = azurerm_resource_group.state.name
  location            = azurerm_resource_group.state.location

  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = "TLS1_2"

  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false # Entra ID auth only
  default_to_oauth_authentication = true

  blob_properties {
    versioning_enabled = true # roll back a corrupted state file

    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
  }

  tags = var.tags
}

# Whoever runs bootstrap needs data-plane access to create the container.
# Role propagation can take a minute; if the first apply fails on the container, re-run it.
resource "azurerm_role_assignment" "deployer_blob" {
  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"

  depends_on = [azurerm_role_assignment.deployer_blob]
}

resource "azurerm_management_lock" "state" {
  name       = "protect-tfstate"
  scope      = azurerm_storage_account.state.id
  lock_level = "CanNotDelete"
  notes      = "Holds all Terraform state. Remove the lock deliberately before deleting."
}

# --- Pipeline identities (OIDC) ------------------------------------------------
resource "azuread_application" "this" {
  for_each     = local.identities
  display_name = "sp-${var.name_prefix}-github-${each.key}"
}

resource "azuread_service_principal" "this" {
  for_each  = local.identities
  client_id = azuread_application.this[each.key].client_id
}

resource "azuread_application_federated_identity_credential" "this" {
  for_each = local.federated_credentials

  application_id = azuread_application.this[each.value.identity].id
  display_name   = each.key
  description    = "GitHub Actions OIDC for ${each.value.subject}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = each.value.subject
}

resource "azurerm_role_assignment" "pipeline" {
  for_each = local.role_assignments

  scope                = var.rbac_scope
  role_definition_name = each.value.role
  principal_id         = azuread_service_principal.this[each.value.identity].object_id
}

# Both identities read and write state (the plan identity needs the blob lease for locking).
resource "azurerm_role_assignment" "pipeline_state" {
  for_each = local.identities

  scope                = azurerm_storage_account.state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.this[each.key].object_id
}
