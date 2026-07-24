#!/bin/bash
set -euo pipefail

log() {
  echo "[$(date '+%H:%M:%S')] $1"
}

erstelle_rg() {
  local name="$1"
  local region="$2"
  log "Würde Ressourcengruppe anlegen: $name in $region"
}

log "Deployment startet"
for env in dev test; do
  erstelle_rg "rg-$env" "westeurope"
done
log "Deployment fertig"
