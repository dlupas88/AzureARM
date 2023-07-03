resource dstdan1502 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'dstdan1502'
  tags: {
    displayName: 'dstdan1502'
  }
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
    tier: 'Standard'
  }
}

resource ubuntuVM1storagedan1502 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: toLower('ubuntuVM1storagedan1502')
  location: resourceGroup().location
  tags: {
    displayName: 'ubuntuVM1 Storage Account'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource ubuntuVM1_PublicIP 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'ubuntuVM1-PublicIP'
  location: resourceGroup().location
  tags: {
    displayName: 'PublicIPAddress'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: toLower('ubuntuVM1')
    }
  }
}

resource ubuntuVM1_nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'ubuntuVM1-nsg'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'nsgRule1'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource ubuntuVM1_VirtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'ubuntuVM1-VirtualNetwork'
  location: resourceGroup().location
  tags: {
    displayName: 'ubuntuVM1-VirtualNetwork'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ubuntuVM1-VirtualNetwork-Subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: ubuntuVM1_nsg.id
          }
        }
      }
    ]
  }
}

resource ubuntuVM1_NetworkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'ubuntuVM1-NetworkInterface'
  location: resourceGroup().location
  tags: {
    displayName: 'ubuntuVM1-NetworkInterface'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: ubuntuVM1_PublicIP.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'ubuntuVM1-VirtualNetwork', 'ubuntuVM1-VirtualNetwork-Subnet')
          }
        }
      }
    ]
  }
  dependsOn: [

    ubuntuVM1_VirtualNetwork
  ]
}

resource ubuntuVM1 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'ubuntuVM1'
  location: resourceGroup().location
  tags: {
    displayName: 'ubuntuVM1'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS3'
    }
    osProfile: {
      computerName: 'ubuntuVM1'
      adminUsername: 'adminUsername'
      adminPassword: 'adminPassword'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'ubuntuVM1-OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: ubuntuVM1_NetworkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: ubuntuVM1storagedan1502.properties.primaryEndpoints.blob
      }
    }
  }
}