STORAGE_NAME="stmarco$RANDOM"
echo $STORAGE_NAME
az storage account create \
  --name "$STORAGE_NAME" \
  --resource-group rg-lab-deploytest \
  --location westeurope \
  --sku Standard_LRS \
  -o none

STORAGE_NAME="stmarco11451"


az storage container create \
  --account-name "$STORAGE_NAME" \
  --name uebung \
  --auth-mode key -o none

echo "Hallo vom Storage, geschrieben am $(date)" > testblob.txt

az storage blob upload \
  --account-name "$STORAGE_NAME" \
  --container-name uebung \
  --name testblob.txt \
  --file testblob.txt \
  --auth-mode key -o none

az storage blob list \
  --account-name "$STORAGE_NAME" \
  --container-name uebung \
  --auth-mode key -o table

curl https://stmarco11451.blob.core.windows.net/uebung/testblob.txt

SAS_TOKEN=$(az storage blob generate-sas \
  --account-name "$STORAGE_NAME" \
  --container-name uebung \
  --name testblob.txt \
  --permissions r \
  --expiry "$(date -u -d '+1 hour' '+%Y-%m-%dT%H:%MZ')" \
  --auth-mode key -o tsv)

echo "https://$STORAGE_NAME.blob.core.windows.net/uebung/testblob.txt?$SAS_TOKEN"