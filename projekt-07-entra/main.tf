resource "azuread_group" "secgroup" {
  for_each = toset(["sec-admins", "sec-devops", "sec-readers"])

  display_name     = each.key
  security_enabled = true
}

resource "azuread_application" "deployer" {
  display_name = "app-tf-deployer"
}

resource "azuread_service_principal" "deployer" {
  client_id = azuread_application.deployer.client_id
}

resource "azuread_conditional_access_policy" "CA01" {
  display_name = "CA01 - Require MFA"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    client_app_types = ["all"]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}