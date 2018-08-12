# Assessment 1

## Requirements

### Functional

1. Create a resource group in West Europe;

2. Create a Storage Account (SA). The SA must be encrypted, has a unique name.
      The name must start with the "sentia" prefix;

3. Create a Virtual Network (VN). The VN must have 3 subnets. The address prefix
     must be 172.16.0.0/12;

4. All the resources must have the following tags: 
    Environment='Test', Company='Sentia'.

5. Create a policy definition using the REST API. It must restrict the
    resourcetypes to only allow: compute, network and storage resourcetypes;

6. Using the REST API, assign the policy defintion to the subscription and
    resource group created previously.

### Non functional

This set of requirements characterize the quality attributes for the 
deployment script. The non functional requirements are:

1. Reusability;

2. Flexibility;

3. Robustness.

## Technical constraints

The solution must satisy the following technical constraints:

1. GIT: all the code must be versioned using this code versioning system;

2. Azure Resource Manager: the deployment script must use ARM to manage the resources
       in the Cloud.

## Presentation

As a presentation format, the author had choosen a standard way to present this
assessment: a deck of slides. 

__TODO__
Here it will be shared the link to the slides. Stay tuned!