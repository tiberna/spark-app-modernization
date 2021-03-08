param location string = 'westeurope'

param sqlServerName string = 'modern-sql'
param sqlDBName string = 'rewardsdb'
param sqlAdminLogin string = 'sqladmin'
param sqlAdminPassword string

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
  }
  tags: {
    app: 'devdays'
    kind: 'database'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${sqlDBName}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource sqlDBRule 'Microsoft.Sql/servers/firewallRules@2015-05-01-preview' = {
  name: '${sqlServer.name}/AllowInternalAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output sqlServerURL string = sqlServer.properties.fullyQualifiedDomainName