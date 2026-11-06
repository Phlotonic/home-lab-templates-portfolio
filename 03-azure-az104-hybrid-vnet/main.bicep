// =====================================================================
// Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
// Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
// Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
// =====================================================================
// Azure AZ-104 Multi-Region Hub-Spoke VNet Peering, Bastion & Key Vault
// =====================================================================

@description('Primary Hub Region')
param primaryLocation string = 'eastus'

@description('Secondary Spoke Region')
param secondaryLocation string = 'westus2'

@description('Administrator Username for Private Workload VM')
param adminUsername string = 'azadmin'

@secure()
@description('SSH Public Key or Password Stored via Key Vault Reference')
param adminSshPublicKey string

@description('Entra ID Principal Object ID for Key Vault & VM RBAC')
param adminPrincipalId string

var hubVnetName = 'vnet-hub-eastus'
var spokeVnetName = 'vnet-spoke-westus2'
var keyVaultName = 'kv-az104-${uniqueString(resourceGroup().id)}'

// 1. Primary Region Hub VNet (East US) with AzureBastionSubnet
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: hubVnetName
  location: primaryLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.10.0.0/26'
        }
      }
      {
        name: 'snet-hub-shared'
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

// 2. Strict NSG for Private Subnet in Secondary Region (West US 2)
resource privateNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-private-workload-westus2'
  location: secondaryLocation
  properties: {
    securityRules: [
      {
        name: 'Allow-Bastion-SSH-Inbound-Only'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.10.0.0/26'
          sourcePortRange: '*'
          destinationAddressPrefix: '10.20.1.0/24'
          destinationPortRange: '22'
        }
      }
      {
        name: 'Allow-Hub-Internal-HTTPS'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.10.1.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '10.20.1.0/24'
          destinationPortRange: '443'
        }
      }
      {
        name: 'Deny-All-Internet-Inbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

// 3. Secondary Region Spoke VNet (West US 2)
resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: spokeVnetName
  location: secondaryLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-private-workload'
        properties: {
          addressPrefix: '10.20.1.0/24'
          networkSecurityGroup: {
            id: privateNsg.id
          }
        }
      }
    ]
  }
}

// 4. Bidirectional Global VNet Peering (East US <-> West US 2)
resource hubToSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: hubVnet
  name: 'peer-hub-to-spoke'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
  }
}

resource spokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: spokeVnet
  name: 'peer-spoke-to-hub'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
  }
}

// 5. Azure Bastion Host in Hub VNet for Browser-Based Encrypted Access
resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'pip-bastion-eastus'
  location: primaryLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2023-11-01' = {
  name: 'bas-hub-eastus'
  location: primaryLocation
  sku: {
    name: 'Standard'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: hubVnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: bastionPip.id
          }
        }
      }
    ]
  }
}

// 6. Private NIC (Zero Public IP) & Workload VM in West US 2
resource privateNic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vm-private-westus2'
  location: secondaryLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: spokeVnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource privateVm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-internal-workload'
  location: secondaryLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'vm-internal'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminSshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: privateNic.id
        }
      ]
    }
  }
}

// 7. Azure Key Vault with RBAC Authorization for Secrets & Connection Strings
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: primaryLocation
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
  }
}

// 8. Least-Privilege RBAC: Key Vault Secrets Officer for Admin & Secrets User for VM Managed Identity
resource kvAdminRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, adminPrincipalId, 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
    principalId: adminPrincipalId
    principalType: 'User'
  }
}

resource kvVmSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, privateVm.id, '4633458b-17de-408a-b874-0445c86b69e6')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: privateVm.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
