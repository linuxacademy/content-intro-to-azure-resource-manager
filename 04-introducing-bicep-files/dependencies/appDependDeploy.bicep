resource webApplication 'Microsoft.Web/sites@2018-11-01' = {
  name: 'awesomewebappq345353'
  location: 'eastus'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'awesomeasp'
  location: 'eastus'
  sku: {
    name: 'F1'
    capacity: 1
  }
}

