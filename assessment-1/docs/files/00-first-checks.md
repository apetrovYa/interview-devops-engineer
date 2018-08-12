# Verificating the development and execution environment

As already said, the deployment script was implemented on a Linux machine
after the installation of the required pieces of software.


For the following sections, open a terminal and execute the following commands.

## Check if Git is installed

```bash

$ git --version
git version 2.17.1

```

## Check if PowerShell is installed

```bash

$pwsh-preview --version
PowerShell 6.1.0-preview.4

```

## Check if Make is installed

```bash

$make -v
GNU Make 4.1
Built for x86_64-pc-linux-gnu
Copyright (C) 1988-2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

```

## Check if Azure Command Line Interface (AZ CLI) is installed

```bash

$az --version
azure-cli (2.0.43)
acr (2.1.2)
acs (2.2.2)
advisor (0.6.0)
ams (0.2.1)
appservice (0.2.1)
backup (1.2.0)
batch (3.3.1)
batchai (0.4.0)
billing (0.2.0)
cdn (0.1.0)
cloud (2.1.0)
cognitiveservices (0.2.0)
command-modules-nspkg (2.0.2)
configure (2.0.18)
consumption (0.4.0)
container (0.3.2)
core (2.0.43)
cosmosdb (0.2.0)
dla (0.2.0)
dls (0.1.0)
dms (0.1.0)
eventgrid (0.2.0)
eventhubs (0.2.1)
extension (0.2.1)
feedback (2.1.4)
find (0.2.12)
interactive (0.3.27)
iot (0.2.0)
keyvault (2.2.1)
lab (0.1.0)
maps (0.3.1)
monitor (0.2.1)
network (2.2.2)
nspkg (3.0.3)
policyinsights (0.1.0)
profile (2.1.1)
rdbms (0.3.0)
redis (0.3.0)
reservations (0.3.1)
resource (2.1.1)
role (2.1.2)
search (0.1.0)
servicebus (0.2.1)
servicefabric (0.1.0)
sql (2.1.1)
storage (2.1.1)
vm (2.2.0)

Python location '/opt/az/bin/python3'
Extensions directory '/home/andov/.azure/cliextensions'

Python (Linux) 3.6.5 (default, Jul 26 2018, 17:46:54)
[GCC 7.3.0]

Legal docs and information: aka.ms/AzureCliLegal

```

## Some checking activities

See if azure connects correctly:

```bash

$az login

```

after that, see if `az` tool retrieves correctly the account inforamtion

```bash

$az account show

{
  "environmentName": "AzureCloud",
  "id": "<hidden>",
  "isDefault": true,
  "name": "Versione di valutazione gratuita",
  "state": "Enabled",
  "tenantId": "<hidden>",
  "user": {
    "name": "<hidden>",
    "type": "user"
  }
}


```

in the previous JSON output `some sensitive information is appositely hidden`. It is provided as an example.

## Configure the environment with proper values

Inside the directory of `assessment-1` it is present the `.env` file.
Its content is as follows:

```bash

#
# .DESCRIPTION
#   The present file helps to populate the environment variables of  
#   a developing machine. These variables are used inside the Makefile file
#   and the DeploymentScript.ps1.
#
#   This file contains only sensitive data. It must not be tracked inside along
#   with other files within a versioning system.  
#
#
# .NOTES
#
#   - ARG: variable defines the container name in which the resources 
#          live.
#
#   - ASID: information related to your Azure Account. To get it use,
#           for example, AZ CLI: az account show.
#
#   - ACR: the region in which the ResourceGroup has to be created.
#
#   - PRU: the complete link of the JSON file defining the  PolicyDefinition.
#
#   - FirstKeyApp, ClientId, TenantId: the data relative to a ServicePrincipal
#     account.
#
# Azure Resource Group name
export ARG=""

# Azure Subscribtion ID (ASID)
export ASID=""

# Azure Cloud Region (ACR)
export ACR=""

# Policy Rules URI
export PRU=""

# ServicePrincipal account credentials
export FirstKeyApp=""
export ClientId=""
export TenantId=""

```

To configure the environment execute the following command: `source ${PROVIDED_PATH}.env`.
The variable *${PROVIDED_PATH}* contains the path to the `assessment-1` directory.

The last thing to do is the provider policy insights registration. Execute the
`az` command attached below:

```bash

$az provider register \
            --namespace 'Microsoft.PolicyInsights'

```

This command makes possible to manage Policies in Azure.

Now, go to the [next page](./10-way-of-doing.md).