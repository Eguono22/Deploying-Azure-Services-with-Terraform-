variable "prefix" {
  description = "Prefix for naming deployed resources."
  type        = string
  default     = "simplewebapp"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "app_service_sku_name" {
  description = "SKU for the Azure App Service plan."
  type        = string
  default     = "B1"
}

variable "web_app_node_version" {
  description = "Node.js runtime version for the Linux web app."
  type        = string
  default     = "18-lts"
}

variable "mysql_admin_username" {
  description = "Admin username for the Azure Database for MySQL server."
  type        = string
  default     = "mysqladmin"
}

variable "mysql_admin_password" {
  description = "Admin password for the Azure Database for MySQL server."
  type        = string
  sensitive   = true
}

variable "mysql_sku_name" {
  description = "SKU for Azure Database for MySQL flexible server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "Version for Azure Database for MySQL flexible server."
  type        = string
  default     = "8.0.21"
}

variable "mysql_database_name" {
  description = "Application database name."
  type        = string
  default     = "appdb"
}
