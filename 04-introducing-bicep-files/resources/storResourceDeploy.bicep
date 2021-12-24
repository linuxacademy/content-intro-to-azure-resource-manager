resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'awesomestorage1343719834'
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
  }
}
