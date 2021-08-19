// Simple example to deploy Azure infrastructure for app + data + managed identity + monitoring

param env string

@secure()
param sqlConnectionString string

// Region for all resources
param location string = resourceGroup().location

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

// Variables
var hostingPlanName = 'plan-coffetechs1-${env}-${location}-001'
var webSiteName = 'app-coffetechs1-site-${env}-${location}-001'
var appInsightsName = 'appi-coffetechs1-${env}-${location}-001'

// Web App resources
resource hostingPlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

resource webSite 'Microsoft.Web/sites@2020-12-01' = {
  name: webSiteName
  location: location
  tags: {
    'hidden-related:${hostingPlan.id}': 'empty'
    displayName: 'Website'
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig:{
      netFrameworkVersion: 'v5.0'
    }    
  }
  identity: {
    type:'SystemAssigned'
  }
}

resource webSiteConnectionStrings 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${webSite.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: sqlConnectionString
      type: 'SQLAzure'
    }
  }
}

// Monitor
resource appInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: appInsightsName
  location: location
  tags: {
    'hidden-link:${webSite.id}': 'Resource'
    displayName: 'AppInsightsComponent'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}


output webSiteName string = webSiteName
output webSiteDefaultHostName string = webSite.properties.defaultHostName
