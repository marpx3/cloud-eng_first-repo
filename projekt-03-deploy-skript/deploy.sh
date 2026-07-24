#!/bin/bash
set -euo pipefail

RG_NAME="rg-lab-deploytest2"
LOCATION="westeurope"
VM_NAME="vm-deploytest2"
VM_SIZE="Standard_D2s_v6"
ADMIN_USER="azureuser"

log() {
  echo "[$(date '+%H:%M:%S')] $1"
}

deploy_rg() {
  log "RessourceGroup: $RG_NAME in Location: $LOCATION"
  az group create --name "$RG_NAME" --location "$LOCATION" -o none
  log "RG angelegt"
}

deploy_vm() {
  log "VM Name: $VM_NAME VM Type: $VM_SIZE Admin: $ADMIN_USER"
  log "Erstelle  VM $VM_NAME"
  az vm create \
    --resource-group "$RG_NAME" \
    --name "$VM_NAME" \
    --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest \
    --size "$VM_SIZE" \
    --admin-username "$ADMIN_USER" \
    --ssh-key-values ~/.ssh/id_ed25519.pub \
    --custom-data cloud-init.yaml \
    -o none
  PUBLIC_IP=$(az vm show -d -g "$RG_NAME" -n "$VM_NAME" --query publicIps -o tsv)
  log "VM steht, öffentliche IP: $PUBLIC_IP"
  log "Check if cloud config is available"
  if [ ! -f "cloud-init.yaml" ]; then
  log "Fehler: keine cloud-init.yaml vorhanden." >&2
  exit 1
  fi
  log "Erfolg: cloud-init.yaml vorhanden"
  log "Fertig: http://$PUBLIC_IP"
}

open_http() {
  log "Öffne Port 80"
  az network nsg rule create \
    --resource-group "$RG_NAME" \
    --nsg-name "${VM_NAME}NSG" \
    --name allow-http \
    --priority 1010 \
    --direction Inbound --access Allow --protocol Tcp \
    --destination-port-ranges 80 \
    -o none
}

log "RG Deploy"
deploy_rg
log "RG Deploy done"
log "VM Deploy"
deploy_vm
log "VM Deploy done"
log "Network Deploy"
open_http
log "Network Deploy done"
