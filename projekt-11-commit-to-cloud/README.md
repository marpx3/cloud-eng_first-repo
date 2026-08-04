# Projekt 11 — App von Commit bis Cloud

Vollautomatisches Deployment: Eine Code-Änderung wird per Pull Request gemergt und ist
ohne manuellen Schritt live in Azure.

## Flow

Commit → PR (terraform-check + tf-plan als Kommentar) → Merge auf main
→ app-deploy: Docker-Build → Push in ACR (Tag = Git-SHA) → az containerapp update → LIVE

## Bausteine

- **Azure Container Apps** (per Terraform, durch die Pipeline deployed): Environment + App,
  externer Ingress, Scale-to-0 → keine Anfragen = keine Compute-Kosten.
- **Auth ohne Secrets:** Pipeline via OIDC/Federated Credentials; die App pullt aus der
  privaten ACR über eine System-Assigned **Managed Identity** mit `AcrPull` (Minimalprinzip).
- **Zuständigkeits-Schnitt:** Terraform verwaltet die App-Struktur, die Pipeline die
  Image-Version — `lifecycle { ignore_changes = [template[0].container[0].image] }`.
- **Tagging:** `${{ github.sha }}` statt `latest` — jedes Image ist exakt einem Commit zuordenbar.
- **`paths`-Filter:** Build läuft nur bei Änderungen unter `projekt-10-container/**`.

## Learnings / Fehlergeschichten

- Rolle auf eine frisch entstehende Managed Identity schlägt im selben Apply fehl → Zwei-Phasen-Deploy.
- **Contributor darf keine Rollen vergeben** (Gewaltenteilung) → Pipeline-SP brauchte zusätzlich
  „Role Based Access Control Administrator" (Bootstrap-Schicht, bewusst mächtig).
- ACR-Repository war plötzlich leer: **Registry-Inhalt ist Daten, nicht IaC** — ein Replace der
  Registry löscht alle Images. Reproduzierbar dank Pipeline-Builds.
- app-deploy „feuerte nicht" — war korrekt: der Merge änderte nur `.github/` (Diagnose: `git show --stat`).
- Neue Subscription: `az provider register --namespace Microsoft.App` nötig (MissingSubscriptionRegistration).

## How to run

Nichts manuell — Änderung unter `projekt-10-container/` per PR mergen, Rest macht die Pipeline.
App-URL: `terraform -chdir=selbsttest-01 output app_url`