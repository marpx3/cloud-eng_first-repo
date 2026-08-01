resource "azuread_application_federated_identity_credential" "github" {
  application_id = data.azuread_application.deployer.id
  display_name   = "github-actions-main"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:marpx3/cloud-eng_first-repo:ref:refs/heads/main"
  audiences      = ["api://AzureADTokenExchange"]
}

resource "azurerm_role_assignment" "github-rbac" {
  principal_id         = data.azuread_service_principal.a-sp.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_subscription.sub.id
}


resource "azuread_application_federated_identity_credential" "github-actions-pr" {
  application_id = data.azuread_application.deployer.id
  display_name   = "github-actions-pr"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:marpx3/cloud-eng_first-repo:pull_request"
  audiences      = ["api://AzureADTokenExchange"]
}

resource "azuread_application_federated_identity_credential" "github-prod" {
  application_id = data.azuread_application.deployer.id
  display_name   = "github-actions-prod"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:marpx3/cloud-eng_first-repo:environment:prod"
  audiences      = ["api://AzureADTokenExchange"]
}