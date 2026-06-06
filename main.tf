terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  lower   = true
  numeric = true
  special = false
  upper   = false
}

locals {
  sanitized_prefix = replace(lower(var.prefix), "/[^a-z0-9]/", "")
  base_prefix      = length(local.sanitized_prefix) > 0 ? local.sanitized_prefix : "app"
  name_prefix      = substr(local.base_prefix, 0, 16)

  resource_group_name = "rg-${local.name_prefix}"
  app_service_plan    = "asp-${local.name_prefix}-${random_string.suffix.result}"
  web_app_name        = "web-${local.name_prefix}-${random_string.suffix.result}"
  mysql_server_name   = "mysql${local.name_prefix}${random_string.suffix.result}"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "main" {
  name                = local.app_service_plan
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
}

resource "azurerm_mysql_flexible_server" "main" {
  name                   = local.mysql_server_name
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  backup_retention_days  = 7
  sku_name               = var.mysql_sku_name
  version                = var.mysql_version
}

resource "azurerm_mysql_flexible_database" "app" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure_services" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_linux_web_app" "main" {
  name                = local.web_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = var.web_app_node_version
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    MYSQL_HOST                          = azurerm_mysql_flexible_server.main.fqdn
    MYSQL_DATABASE                      = azurerm_mysql_flexible_database.app.name
  }

}
