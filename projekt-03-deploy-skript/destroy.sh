#!/bin/bash
set -euo pipefail

RG_NAME="rg-lab-deploytest"

log() {
  echo "[$(date '+%H:%M:%S')] $1"
}

delete_rg() {
  log "check if $RG_NAME exist"
  if [ "$(az group exists --name "$RG_NAME")" = "false" ]; then
  log "FEHLER: Gruppe exisitiert nicht" >&2
  exit 1
  fi 
  log "RessourceGroup: $RG_NAME wird gelöscht"
  az group delete --name "$RG_NAME" --yes
  log "ERFOLG: Gruppe $RG_NAME gelöscht"
}

delete_rg