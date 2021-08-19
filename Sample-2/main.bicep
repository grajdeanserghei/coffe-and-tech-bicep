targetScope='subscription'

param env string

param location string

@secure()
param sqlConnectionString string

// Web App params
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param skuName string = 'F1'

@minValue(1)
param skuCapacity int = 1

var resourceGroupName = 'rg-coffetechs2-${env}-${location}'

resource envRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
}


module application 'application.bicep' = {
  scope: envRG
  name: 'applicationResources'
  params:{
    location: location
    env: env
    sqlConnectionString: sqlConnectionString
    skuName: skuName
    skuCapacity: skuCapacity
  }
}

output webSiteName string = application.outputs.webSiteName
output webSiteDefaultHostName string = application.outputs.webSiteDefaultHostName
