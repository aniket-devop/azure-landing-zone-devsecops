output "github_repository_variables" {
  description = "Create these as repository VARIABLES (not secrets) in GitHub: Settings > Secrets and variables > Actions > Variables."
  value = {
    AZURE_TENANT_ID        = data.azurerm_client_config.current.tenant_id
    AZURE_PLAN_CLIENT_ID   = azuread_application.this["plan"].client_id
    AZURE_APPLY_CLIENT_ID  = azuread_application.this["apply"].client_id
    TFSTATE_RESOURCE_GROUP = azurerm_resource_group.state.name
    TFSTATE_STORAGE        = azurerm_storage_account.state.name
    TFSTATE_CONTAINER      = azurerm_storage_container.state.name
  }
}
