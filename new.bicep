param location string = resourceGroup().location
param storageName string = 'prodstorage${uniqueString(resourceGroup().id)}'
param vnetName string = 'prod-vnet'
param subnetName string = 'prod-aks-subnet' 
param aksName string = 'prod-aks'
param dnsprefix string = 'prodaksdns'



resource storage 'microsoft.storage/storageAccounts@2025-01-10' = {
  name: storageName
  location: location
  sku: {
    name: 'standard_LRS'
  }
  kind: 'storagev2'
  properties: {} 
}

resource vnet 'Microsoft.Network/virtualNetworks@2025-02-02' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressprefix: '10.1.1.0/24'

        }
      }
    ]

    }
    
    }
  
  
  
  resource aks 'Microsoft.containerservice/managedClusters@2024-02-02-preview' = {
    name: aksName
    location: location
    identity: {
      type: 'SystemAssigned'
    }
    properties: {
      dnsPrefix: dnsprefix
      enableRBAC: true
      kubernetesVersion: '1.29.2'
      agentPoolProfiles: [
        {
          name: 'systempool'
          vmSize: 'Standard_DS3_v2'
          count: 3
          mode: 'System'
          vnetSubnetId: vnet.properties.subnets[0].id
        }
      ]
      networkProfile: {
        networkPlugin: 'azure'
        networkPolicy: 'azure'
      }
    }
  }
   