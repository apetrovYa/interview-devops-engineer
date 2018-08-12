# Assessment 1

## Requirements

### Functional

1. Create a ResourceGroup in West Europe;

2. Create a Storage Account (SA). The SA must be encrypted, has a Unique Name.
   The name must have the string "sentia" as prefix;

3. Create a Virtual Network (VN). The created VN must have 3 subnets.
   The address prefix must be 172.16.0.0/12;

4. All the resources must have the following tags:

    - Environment='Test';

    - Company='Sentia'.

5. Using the REST API:

    - Create a PolicyDefinition, that restricts the resourcetypes to only:

        - Microsoft.Compute/*;

        - Microsoft.Network/*;

        - Microsoft.Storage/*;

6. Assign the policy defintion to the SubscriptionId and Resource Group
   created previously.

### Non functional

The following set of requirements characterize the quality attributes
for the deployment script. These requirements are:

1. Reusability;

2. Flexibility;

3. Robustness.

## Technical constraints

The solution must satisy the following technical constraints:

1. Git: code versioning technology;

2. Azure Resource Manager: Azure technology for managing cloud resources
    in a declarative manner.

## Presentation

As a presentation format, the author had choosen a standard way to present this
assessment: a deck of slides.

__TODO__
Here it will be shared the link to the slides. Stay tuned!