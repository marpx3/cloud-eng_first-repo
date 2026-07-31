data "azuread_application" "deployer" {
  display_name = "app-tf-deployer"
}

data "azuread_service_principal" "a-sp" {
  client_id = data.azuread_application.deployer.client_id
}

data "azurerm_subscription" "sub" {

}