# Non-secret settings. Subscription IDs are NOT stored here; the pipeline injects
# them as TF_VAR_* from repository variables.
org_id            = "contoso"
org_display_name  = "Contoso"
location          = "centralindia"
allowed_locations = ["centralindia", "southindia"]

required_tags = ["owner", "environment", "cost-center"]

# Start in audit mode, review compliance, then flip to true.
policy_enforce = false

hub_address_space    = "10.0.0.0/22"
spoke_address_spaces = ["10.1.0.0/16"]

# Firewall is the main cost driver. Keep false while experimenting.
deploy_firewall = false
deploy_bastion  = false

tags = {
  owner       = "platform-team"
  environment = "platform"
  cost-center = "it-001"
}
