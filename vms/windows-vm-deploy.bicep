param subscriptionId string = '2fbf906e-1101-4bc0-b64f-adc44e462fff'
param kvResourceGroup string = 'TIM'
param kvName string = 'tim-keyvault-001'

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: kvName
  scope: resourceGroup(subscriptionId, kvResourceGroup)
}

module vm 'windows-vm.bicep' = {
  name: 'deploy-windows-vm'
  params: {
    adminUsername: 'tim'
    adminPasswordOrKey: kv.getSecret('adminPassword')
    vmName: 'win1'
    vmSize: 'Standard_D2_v3'
    createNewStorageAccount: false
    createNewVnet: false
    vnetName: 'hub-vnet'
    addressPrefixes: [
      '10.40.0.0/16'
      ]
    subnetName: 'web'
    subnetPrefix: '10.40.1.0/24'
    vnetResourceGroupName: 'rg1'
    createNewPublicIP: false
  }
}
