param location string = 'westeurope'

param sqlServerName string = 'modern-spark-sql'
param sqlDBName string = 'rewardsdb'
param sqlAdminLogin string
param sqlAdminPassword string

param appName string = 'spark-modern-app'
param dockerRegistryUrl string = 'https://mcr.microsoft.com'
param dockerRegistryUsername string = ''
param dockerRegistryPassword string = ''
param dockerImage string = 'mcr.microsoft.com/azure-app-service/samples/aspnethelloworld:latest'

param acrName string = 'modernspark'

module sql './modern-infra-db.bicep' = {
  name: 'sqlDeploy'
  params: {
    location: location
    sqlServerName: sqlServerName
    sqlDBName: sqlDBName
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
  }
}

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

output sqlServerURL string = sql.outputs.sqlServerURL
output appServiceURL string = app.outputs.appServiceURL
output acrURL string = acr.outputs.acrLoginServer
