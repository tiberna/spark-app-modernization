param location string
param appName string
param dockerRegistryUrl string
param dockerRegistryUsername string
param dockerRegistryPassword string
param dockerImage string

var appServicePlanName = toLower('asp-${appName}')
var dockerRuntimeCommand = 'DOCKER|${dockerImage}'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName // Globally unique storage account name
  location: location // Azure Region
  kind: 'windows'
  sku: {
    tier: 'PremiumV3'
    name: 'P1V3'
  }
  tags: {
    app: 'spark'
    kind: 'webapp'
  }
  properties: {
    targetWorkerCount: 6
    targetWorkerSizeId: 6
    hyperV: true
  } 
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appName
  location: location
  tags: {
    app: 'spark'
    kind: 'webapp'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings:[
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: dockerRegistryUrl
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: dockerRegistryUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: dockerRegistryPassword
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      windowsFxVersion: dockerRuntimeCommand
      appCommandLine: ''
      alwaysOn: true
    }
  }
}

resource appServiceSlot 'Microsoft.Web/sites/slots@2020-06-01' = {
  name: '${appService.name}/canary'
  location: location
  
  tags: {
    app: 'spark'
    kind: 'webapp-slot'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
  kind: 'app'
}

output appServiceURL string = appService.properties.defaultHostName