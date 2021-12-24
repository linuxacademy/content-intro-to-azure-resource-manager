// Example of parent and child resources in seperate resources

resource storageaccount1 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'seperatestorage234tg2r45'
  location: 'eastus'
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




// Example of parent and child resources nested within the parent resource

resource storageaccount2 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'nestedstorage198745'
  location: 'eastus'
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


