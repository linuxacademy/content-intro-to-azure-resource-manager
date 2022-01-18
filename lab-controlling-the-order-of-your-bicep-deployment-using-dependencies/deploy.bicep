var location = resourceGroup().location
var baseName = toLower(uniqueString(resourceGroup().id))

// Example of seperate dependant resources

resource webApplication 'Microsoft.Web/sites@2018-11-01' = {
  name: 'webapp${baseName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'appsrvcpln${baseName}'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

// Example of parent and child resources nested within the parent resource

resource storageaccount2 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'nestedstg${baseName}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
  resource blob2 'blobServices' = {
    name: 'default'

    resource container2 'containers' = {
      name: 'nestedcontainer'
      
    }
    
  }
}

// Example of parent and child resources in seperate resources

resource storageaccount1 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'seperatestg${baseName}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

resource blob1 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: 'default'
  parent: storageaccount1
}

resource container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: 'seperatecontainer'
  parent: blob1
}
