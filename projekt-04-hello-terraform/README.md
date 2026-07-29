### Summary
    Abbilden der deploy.sh in Terraform.

1. Definieren der provider ( Standard gerüst terraform{} und provider "azurerm {}")

2. Definieren der Resourcen. 
    Beispiel resource "azurerm_storage_account" "lab" {}
    -> Terraform Doku liefert die genauen Bezeichnungen und nötigen Eigenschaften

3. Wichtige Terraform Commands
    Terraform fmt -> korrigiert einrückung
    terraform validate -> prüft syntax
    terraform plan -> vergleicht mit dem state und zeigt Änderungen an
    terraform apply -> Für die Änderungen/Anlagen durch
    terraform destroy -> löscht die Umgebung vollständig
    terraform init -> Initial befehl bei nutzung eines Backend TFstates
    terraform init -migrate-state -> Switch von lokal zu remote

4. .tf aufteilen
    .tf Dateien können aufgeteilt werden (Bsp. main.tf, provider.tf, variables.tf, ...)
    Terraform klebt die .tf File in einem Ordner automatisch zusammen

5. Variablen
    Variablen können definiert werden und mit validations versehen werden
    Werden mit "${var.<variable>}" oder var.<variable> gesetzt
    auf der CLI mit terraform plan -var="<variable>=DEINEVariable"
    oder per .tfvars file

6. Locals
    Ist von außen unsichar und kann im Code Werte konstruieren die bsp. in Schleifen genutzt werden können

7. .tfvars
    Files in denen mehrere Variablen gesetzt werden die für diese Kategorie gleich sein Bsp. dev/prod
    Die .tfvars werden dann beim Befehl mit aufgerufen. 
    Bsp: terraform plan -var-file="dev.tfvars" 

8. Output
    Output kann über output "blabla" {
        value = <Ausgabe/Call>
    }

9. Remote Backend
    Um im Team zu arbeiten oder auch den lokalen verlust der .tfstate vorzubeugen ist es notwendig die .tfstate in einem storageaccount zu speichern. Henne-Ei Problem: Wer legt es an? der eigene Terraform code? -> Pragmatische Lösung inital mit dokumentiertem skript oder eigenes tf projekt nur für den state.
