provider "azurerm" {
  features {}
  subscription_id = "e84d8697-ef3e-4296-9629-cdeb0c1df544"
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# App Service Plan
resource "azurerm_app_service_plan" "asp" {
  name                = var.asp_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# App Service
resource "azurerm_app_service" "app" {
  name                = var.as_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
  site_config {
    linux_fx_version = "DOTNETCORE|8.0"
  }
  app_settings = {
    "SCM_BASIC_AUTH_PUBLISHING_ENABLED" = "true"
    "FTP_BASIC_AUTH_PUBLISHING_ENABLED" = "true"
  }
}
