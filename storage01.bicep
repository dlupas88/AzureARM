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