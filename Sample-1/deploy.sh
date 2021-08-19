az group create -l uksouth -n rg-coffetechs1-dev

az deployment group create \
    --resource-group rg-coffetechs1-dev \
    --template-file ./main.bicep \
    --parameters env=dev \
        sqlConnectionString=SomeSecureConnectionString