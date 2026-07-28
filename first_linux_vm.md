### create resource group
az group create --name rg-linux-lab --location germanywestcentral
az group create --name rg-linux-lab --location westeurope

### delete resource group
az group delete --name rg-linux-lab --yes

### create VM
az vm create \
  --resource-group rg-linux-lab \
  --name vm-linux-lab \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --ssh-key-values ~/.ssh/id_ed25519.pub


az vm create \
  --resource-group rg-linux-lab \
    --name vm-linux-lab \
      --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest \
        --size Standard_D2s_v6 \
          --admin-username azureuser \
            --ssh-key-values ~/.ssh/id_ed25519.pub

