param location string = 'westeurope'

param appName string = 'devdays-modern-app'
param dockerRegistryUrl string = 'https://mcr.microsoft.com'
param dockerRegistryUsername string = ''
param dockerRegistryPassword string = ''
param dockerImage string = 'mcr.microsoft.com/azure-app-service/samples/aspnethelloworld:latest'

param acrName string = 'moderndevdays'

module app './modern-infra-app.bicep' = {
  name: 'appDeploy'
  params: {
    location: location
    appName: appName
    dockerRegistryUrl: dockerRegistryUrl
    dockerRegistryUsername: dockerRegistryUsername
    dockerRegistryPassword: dockerRegistryPassword
    dockerImage: dockerImage
  }
}

module acr './modern-infra-acr.bicep' = {
  name: 'acrDeploy'
  params: {
    location: location
    acrName: acrName
    acrAdminUserEnabled: true
  }
}
output appServiceURL string = app.outputs.appServiceURL
output acrURL string = acr.outputs.acrLoginServer
