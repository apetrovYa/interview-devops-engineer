# Deployment guide

In this section, I will show how to launch the script and create the resources
in Azure.

## What we need

We need the following things to be done and provided:

1. An Azure account with sufficient permissions for creating different resource types.

2. A configured working environment (*Linux*), as described [here](./00-first-checks.md).

## How to

To launch the deployment script:

```bash

# 1. Clone the repository from Github
git clone https://github.com/apetrovYa/interview-devops-engineer.git

# 2. Go inside the directory
cd ./interview-devops-engineer/assessment-1/

# 3. Populate with the appropiate data the file .env
# For example, open it with Vim
vim .env

# 4. Export the variables
source .env

# 5. Check the exported environment variables
# Have a look for ASID=...
env | grep -i asid

# 6. If the variable is set correctly, continue
# 7. Go inside the directory scripts
cd scripts

# 8. Launch the PowerShell CLI
# For example:
pwsh-preview

# 9. Check if it started
$PSVersionTable # See the output, it should be similar to

Name                           Value
----                           -----
PSVersion                      6.1.0-preview.4
PSEdition                      Core
GitCommitId                    6.1.0-preview.4
OS                             Linux 4.15.0-32-generic #35-Ubuntu SMP Fri Aug 10 17:58:07 UTC 2018
Platform                       Unix
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0

# 10. Launch the script
./DeploymentScript.ps1 -resourceGroupName "sentia" -resourceGroupLocation "westeurope" -deploymentName "dev"

# 11. If no errors came out, get the information about the deployment
Get-AzureRmResourceGroupDeployment -ResourceGroupName sentia

DeploymentName          : NetworkLinkedTemplate
ResourceGroupName       : sentia
ProvisioningState       : Succeeded
Timestamp               : 8/26/18 3:17:11 PM
Mode                    : Incremental
TemplateLink            :
                          Uri            : https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/templates/VirtualNetwork.template.json
                          ContentVersion : 1.0.0.0

Parameters              :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          virtualNetworkName  String                     sentia
                          networkPrefix    String                     172.16
                          networkPostfix   String                     0.0
                          networkBlock     String                     12
                          subnetBlock      String                     24
                          subnetCount      Int                        3

Outputs                 :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          azureNetworkObject  Object                     {
                            "provisioningState": "Succeeded",
                            "resourceGuid": "5c46e57e-08d1-47a5-8f8e-e13626665d15",
                            "addressSpace": {
                              "addressPrefixes": [
                                "172.16.0.0/12"
                              ]
                            },
                            "subnets": [
                              {
                                "name": "sentia-0",
                                "id": "/subscriptions/f160b75d-40d9-41d5-b1a2-1f6f2554361a/resourceGroups/sentia/providers/Microsoft.Network/virtualNetworks/sentia/subnets/sentia-0",
                                "etag": "W/\"457d68f4-4446-4439-82f1-c0baaef711a0\"",
                                "properties": {
                                  "provisioningState": "Succeeded",
                                  "addressPrefix": "172.16.0.0/24"
                                },
                                "type": "Microsoft.Network/virtualNetworks/subnets"
                              },
                              {
                                "name": "sentia-1",
                                "id": "/subscriptions/f160b75d-40d9-41d5-b1a2-1f6f2554361a/resourceGroups/sentia/providers/Microsoft.Network/virtualNetworks/sentia/subnets/sentia-1",
                                "etag": "W/\"457d68f4-4446-4439-82f1-c0baaef711a0\"",
                                "properties": {
                                  "provisioningState": "Succeeded",
                                  "addressPrefix": "172.16.1.0/24"
                                },
                                "type": "Microsoft.Network/virtualNetworks/subnets"
                              },
                              {
                                "name": "sentia-2",
                                "id": "/subscriptions/f160b75d-40d9-41d5-b1a2-1f6f2554361a/resourceGroups/sentia/providers/Microsoft.Network/virtualNetworks/sentia/subnets/sentia-2",
                                "etag": "W/\"457d68f4-4446-4439-82f1-c0baaef711a0\"",
                                "properties": {
                                  "provisioningState": "Succeeded",
                                  "addressPrefix": "172.16.2.0/24"
                                },
                                "type": "Microsoft.Network/virtualNetworks/subnets"
                              }
                            ],
                            "virtualNetworkPeerings": []
                          }

DeploymentDebugLogLevel :

DeploymentName          : StorageAccountLinkedTemplate
ResourceGroupName       : sentia
ProvisioningState       : Succeeded
Timestamp               : 8/26/18 3:16:38 PM
Mode                    : Incremental
TemplateLink            :
                          Uri            : https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/templates/StorageAccount.template.json
                          ContentVersion : 1.0.0.0

Parameters              :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          storageAccountPrefixName  String                     sentia
                          storageAccountType  String                     Standard_LRS
                          enableEncryption  Bool                       True

Outputs                 :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          accountName      String                     sentiaj7vunu2o4q2fc

DeploymentDebugLogLevel :

DeploymentName          : dev
ResourceGroupName       : sentia
ProvisioningState       : Succeeded
Timestamp               : 8/26/18 3:17:17 PM
Mode                    : Incremental
TemplateLink            :
                          Uri            : https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/main.template.json
                          ContentVersion : 1.0.0.0

Parameters              :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          saPrefixName     String                     sentia
                          saType           String                     Standard_LRS
                          saEnableEncryption  Bool                       True
                          vnName           String                     sentia
                          netPrefix        String                     172.16
                          nPostfix         String                     0.0
                          nBlock           String                     12
                          sBlock           String                     24
                          sCount           Int                        3

Outputs                 :
                          Name             Type                       Value
                          ===============  =========================  ==========
                          storageAccountInfo  String                     sentiaj7vunu2o4q2fc
                          networkInfo      Object                     {
                            "provisioningState": "Succeeded",
                            "resourceGuid": "5c46e57e-08d1-47a5-8f8e-e13626665d15",
                            "addressSpace": {
                              "addressPrefixes": [
                                "172.16.0.0/12"
                              ]
                            },
                            "subnets": [
                              {
                                "name": "sentia-0",
                                "id": "/subscriptions/f160b75d-40d9-41d5-b1a2-1f6f2554361a/resourceGroups/sentia/providers/Microsoft.Network/virtualNetworks/sentia/subnets/sentia-0",
                                "etag": "W/\"457d68f4-4446-4439-82f1-c0baaef711a0\"",
                                "properties": {
                                  "provisioningState": "Succeeded",
                                  "addressPrefix": "172.16.0.0/24"
                                },
                                "type": "Microsoft.Network/virtualNetworks/subnets"
                              },
                              {
                                "name": "sentia-1",
                                "id": "/subscriptions/f160b75d-40d9-41d5-b1a2-1f6f2554361a/resourceGroups/sentia/providers/Microsoft.Network/virtualNetworks/sentia/subnets/sentia-1",
                                "etag": "W/\"457d68f4-4446-4439-82f1-c0baaef711a0\"",
                                "properties": {
                                  "provisioningState": "Succeeded",
                                  "addressPrefix": "172.16.1.0/24"
                                },
                                "type": "Microsoft.Network/virtualNetworks/subnets"
                              },
                              {
                                "name": "sentia-2",
                                "id": "/subscriptions/f160b75d-40d9-41d5-b1a2-1f6f2554361a/resourceGroups/sentia/providers/Microsoft.Network/virtualNetworks/sentia/subnets/sentia-2",
                                "etag": "W/\"457d68f4-4446-4439-82f1-c0baaef711a0\"",
                                "properties": {
                                  "provisioningState": "Succeeded",
                                  "addressPrefix": "172.16.2.0/24"
                                },
                                "type": "Microsoft.Network/virtualNetworks/subnets"
                              }
                            ],
                            "virtualNetworkPeerings": []
                          }

DeploymentDebugLogLevel :


```

Go to the next section about [next-improvements](./30-next-improvements.md).