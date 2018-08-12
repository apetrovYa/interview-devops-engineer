# It's necessary to set this because some environments don't link sh -> bash.
SHELL := /bin/bash

# Variables

RESOURCE_GROUP 		= ${ARG}
SUBSCRIPTION_ID 	= ${ASID}
CLOUD_REGION 		= ${ACR}
POLICY_RULES_URI	= ${PRU}
POLICY_PARAMS_URI	= ${PPU}

all: a-resource-group \
	 a-tag-on-resource-group \
	 a-main-deployment

a-resource-group:
		az group create \
				--name ${RESOURCE_GROUP} \
				--subscription ${SUBSCRIPTION_ID}  \
				--location ${CLOUD_REGION}

a-tag-on-resource-group:
		az group update \
				--name ${RESOURCE_GROUP} \
				--set tags.Environment=Test tags.Company=Sentia

a-resource-group-deletion:
		az group delete \
				--name ${RESOURCE_GROUP}

a-list-of-resource-groups:
		az group list

a-network-template-validation:
		az group deployment validate \
			--resource-group ${RESOURCE_GROUP} \
			--template-file ./templates/VirtualNetwork.template.json

an-sa-template-validation:
	    az group deployment validate \
		   --resource-group ${RESOURCE_GROUP} \
			--template-file ./templates/StorageAccount.template.json

a-main-template-validation:
		az group deployment validate \
		   --subscription ${SUBSCRIPTION_ID} \
		   --resource-group ${RESOURCE_GROUP} \
		   --template-file ./main.template.json \
		   --parameters @main.parameters.json 

a-main-deployment:
		az group deployment create \
			--subscription ${SUBSCRIPTION_ID} \
			--resource-group ${RESOURCE_GROUP} \
			--template-file ./main.template.json \
			--parameters @main.parameters.json \
			--debug --verbose

a-policy-definition:
		az policy definition create \
			--name 'allowed-resource-types' \
			--display-name 'Allowed Group' \
			--description 'This policy enables you to specify the resource types that your developers can deploy' \
			--rules ${POLICY_RULES_URI} \
			--mode All

a-policy-assignment:
		az policy assignment create \
                --name 'allow-resourcetypes-assignment' \
                --display-name 'An assignment to Allow Resource Types in a given ResourceGroup' \
				--policy 'allowed-resource-types' \
				-g ${RESOURCE_GROUP} 

a-provider-policy-insights-registration:
		az provider register --namespace 'Microsoft.PolicyInsights'