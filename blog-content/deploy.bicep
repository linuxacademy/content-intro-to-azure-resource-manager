param vmUserName string = 'awesomeadmin'
@secure()
param vmPass string

@allowed([
  'windows'
  'linux'
])
@description('''
- To deploy a Windows VM use the value "windows"
- To deploy a Linux VM use the value "linux"
''')
param windowsOrlinux string

var location = resourceGroup().location
var baseName = uniqueString(resourceGroup().id)
var vmSize = 'Standard_DS1_v2' 
var image = {
  windows: {
    publisher: 'MicrosoftWindowsServer'
    offer: 'WindowsServer'
    sku: '2019-Datacenter'
    version: 'latest'
  }
  linux: {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18.04-LTS'
    version: 'latest'
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'vm${baseName}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'vm${baseName}'
      adminUsername: vmUserName
      adminPassword: vmPass
    }
    storageProfile: {
      imageReference: {
        publisher: image[windowsOrlinux].publisher
        offer: image[windowsOrlinux].offer
        sku: image[windowsOrlinux].sku
        version: image[windowsOrlinux].version
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'nic${baseName}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet${baseName}', 'subnet${baseName}')
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', 'nsg${baseName}')
    }
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: 'ip${baseName}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg${baseName}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          priority: 300
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet${baseName}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet${baseName}'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

