### LEARNING

Github Action ermöglichen tests die sicherstellen das PRs diese erfüllen bevor sie auf main gemerged werden. 

Es gibt verschiedene "on" Varianten. Wir haben bisher push (wird automatisch nach dem PR commit durchgeführt) und workflow_dispatch (eine prüfung die per knopfdruck ausgeführt wird) implementiert

Branch Rulesets eingerichtet damit main entsprechend geschützt ist

Github -> Azure Zugriff per OIDC über einen Azure App deployed und den Zugriff getestet

.yml files für die github workflows angelegt
    on: Push prüfung ob der TF code korrekt formatiert (fmt) und validiert    ist (validate)

es können mehrer prover in einer provider tf file genutzt werden

git / github Zyklus in Teams geschärft - Wie arbeitet man in Teams mit branches?