terraform {
  backend "azurerm" {
    resource_group_name   = "key-vault-RG"
    storage_account_name  = "backendstate"
    container_name        = "key-vault"
    key                   = "terraform.tfstate"
    
  }
}

//checking.

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "this" {
  name = "key-vault-RG"
}


# resource "azurerm_resource_group" "this" {
#   name     = "key-vault-RG"
#   location = "eastus2"
# }

resource "azurerm_key_vault" "this" {
  name                        = "key-vault-uyi"
  location                    = data.azurerm_resource_group.this.location
  resource_group_name         = data.azurerm_resource_group.this.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Create"
    ]

    secret_permissions = [
      "Get", "Set"
    ]

  }

}

resource "azurerm_key_vault_secret" "this" {
  name         = "testing5-secret"
  value        = "bankeuyiosa05"
  key_vault_id = azurerm_key_vault.this.id
}