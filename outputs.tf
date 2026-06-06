output "resource_group_name" {
  description = "Resource group containing the deployment."
  value       = azurerm_resource_group.main.name
}

output "web_app_name" {
  description = "Azure App Service web app name."
  value       = azurerm_linux_web_app.main.name
}

output "web_app_url" {
  description = "Default URL of the deployed web app."
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "mysql_server_fqdn" {
  description = "FQDN of the MySQL flexible server."
  value       = azurerm_mysql_flexible_server.main.fqdn
}
