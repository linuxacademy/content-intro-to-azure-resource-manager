var location = resourceGroup().location
var baseName = toLower(uniqueString(resourceGroup().id))

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'stg${baseName}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}
