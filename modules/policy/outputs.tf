output "assignment_ids" {
  description = "IDs of all policy assignments created by this module."
  value = merge(
    { for k, v in azurerm_management_group_policy_assignment.builtin : k => v.id },
    { for k, v in azurerm_management_group_policy_assignment.custom : k => v.id }
  )
}
