<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template   

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
   The resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFileUri
    Optional, the path to the template file. Defaults to https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/main.template.json.

 .PARAMETER parametersFileUri
    Optional, the path to the parameters file. Defaults to https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/main.parameters.json.

 .PARAMETER policyDefinitionUri
    Optional, the path to the parameters file. Defaults to https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/policies/AllowOnlySpecificResourceTypes.rules.json

 .PARAMETER tags
    Optional, a set of tags. Defaults to @{ Environment="Test"; Company="Sentia" }
 
 .PARAMETER policyDefinitionName
    Optional, the name of a PolicyDefiniton object. Defaults to 'allow-specific-resourcetypes'
 
 .PARAMETER policyDefinitionDisplayName
    Optional, the general information about the PolicyDefinition object. Defaults to 'Allowed resourcetypes' 

 .PARAMETER policyDefinitionDescription
    Optional, the detailed information about the PolicyDefinition object. Defaults to 'This policy definition allows only Microsoft.{Compute,Network,Storage} resourcetypes'

 .PARAMETER policyAssignmentName
    Optional, the name of a PolicyAssignment object. Defaults to 'enforce-allowed-resourcetypes'

 .PARAMETER policyAssignmentDisplayName
    Optional, the general information about the PolicyAssignment object. Defaults to 'Limit the instantiable resourcetypes'

 .PARAMETER policyAssignmentDescription
    Optional, the detailed information about the PolicyAssignment object. Defaults to 'This assignement forces only a limited subset of Azure resources to be instantiated'
 
 .NOTES
    Author: Andrei Petrov
    Purpose: Deploy a StorageAccount, VirtualNetwork, PolicyDefinition and a PolicyAssignement in a ResourceGroup
    Status: Released
    Date: 2018-08-31
    

    Permission is hereby granted, free of charge, to any person   obtaining a copy 
    of this software and associated documentation files (the "Software"), to deal 
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense,  and/or sell 
    copies of the Software, and to permit persons to whom  the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be  included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,  EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF   MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT    SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER      DEALINGS IN THE
    SOFTWARE.
 #>

param(
 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,
 
 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $deploymentName,

 [string]
 $templateFileUri="https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/main.template.json",

 [string]
 $parametersFileUri="https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/main.parameters.json",
 
 [string]
 $policyDefinitionUri="https://raw.githubusercontent.com/apetrovYa/interview-devops-engineer/master/assessment-1/policies/AllowOnlySpecificResourceTypes.rules.json",
 
 [hashtable]
 $tags=@{ Environment="Test"; Company="Sentia" },

 [string]
 $policyDefinitionName="allow-specific-resourcetypes",
    
 [string]
 $policyDefinitionDisplayName="Allowed resourcetypes",
 
 [string]
 $policyDefinitionDescription="This policy definition allows only Microsoft.{Compute,Network,Storage} resourcetypes",
 
 [string]
 $policyAssignmentName="enforce-allowed-resourcetypes",

 [string]
 $policyAssignmentDisplayName="Limit the instantiable resourcetypes",

 [string]
 $policyAssignmentDescription="This assignement forces only a limited subset of Azure resources to be instantiated",
 
 [string]
 $policyDefinitionApiVersion="2018-03-01"
 )

#******************************************************************************
# Global variables: use them with care!
#******************************************************************************

$ErrorActionPreference="Stop"
#Requires -Version 6.1.0 -Modules @{ModuleName="AzureRM.Insights.Netcore"; ModuleVersion="0.13.1"} -Modules @{ModuleName="AzureRM.Profile.Netcore"; ModuleVersion="0.13.1"} -Modules @{ModuleName="AzureRM.Resources.Netcore"; ModuleVersion="0.13.1"} -Modules @{ModuleName="PSReadLine"; ModuleVersion="2.0.0"}    

#******************************************************************************
# FUNCTIONS DEFINITIONS
#******************************************************************************  
#
# UTILITIES
#
function PrintOutputMessage() 
{
    <#
        .SYNOPSIS
          Print on Standard Output a Message.
    #>
    [CmdletBinding()]
    param(
        [string]
        $inputText
    )
    Write-Output $Local:inputText
}


function PrintHowToGetAzureRMLogs() 
{
    <#
        .SYNOPSIS 
            Print  a message with a suggestion on how to get logs from ARM.
    #>

    PrintOutputMessage "To get any detailed information about your actions using a valid Tracking ID, invoke:"
    PrintOutputMessage "Get-AzureRMLog -CorrelationId {{ correlationId }} -DetailedOutput"
}


function isNotNull() 
{
    <#
        .SYNOPSIS 
            Check if parameter is not equal to $Null value.
    #>
    [CmdletBinding()]
    param(
        [string]
        $a
    )
    return ($Null -ne $a)
}

function checkInput() 
{
    <#
        .SYNOPSIS 
            Check if a set of 3 parameters are properly defined and
            diverse than $Null value.
    #>
    [CmdletBinding()]
    param(
        [string]
        $a,
        [string]
        $b,
        [string]
        $c
    )
    return ($Null -ne $a ) -and ($Null -ne $b) -and ($Null -ne $c)
}

#
# ACCOUNT MANAGEMENT
#

function LoginToAzureCloud() 
{
    <#
        .SYNOPSIS
          Login to the Azure Cloud.
    #>           
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage='Please insert the ServicePrincipal secret Key information' 
        )]
        [string]
        $clientSecret,

        [Parameter(
            Mandatory=$True,
            HelpMessage='Please insert the ServicePrincipal Application Id information'
        )]
        [string]
        $clientID,

        [Parameter(
            Mandatory=$True,
            HelpMessage='Please insert the Azure Account TenantId information'
        )]
        [string]
        $tenantId
    )

        $secure=ConvertTo-SecureString $Local:clientSecret -AsPLainText -Force
        $credential= New-Object System.Management.Automation.PSCredential($Local:clientID,$Local:secure)
        
        try {
            Login-AzureRmAccount -ServicePrincipal `
                                 -Credential $Local:credential `
                                 -TenantId $Local:tenantId `
                                 -ErrorAction Stop
            return $True
        } 
        catch 
        {
              PrintOutputMessage "Login procedure failed."
              return $False  
        }    
        
}

function GetBearerToken() 
{
    <#
        .SYNOPSIS
           Create a Bearer access token for any comunication with ARM via REST APIs.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage='Please insert the ServicePrincipal secret Key information' 
        )]
        [string]
        $clientSecret,

        [Parameter(
            Mandatory=$True,
            HelpMessage='Please insert the ServicePrincipal Application Id information'
        )]
        [string]
        $clientID,

        [Parameter(
            Mandatory=$True,
            HelpMessage='Please insert the Azure Account TenantId information'
        )]
        [string]
        $tenantId
    )
    
    $tokenEndpoint      = {https://login.windows.net/{0}/oauth2/token} -f $tenantId
    $armResource        = "https://management.core.windows.net/"
    $outputProjection   = "access_token"
    
    $body = @{
            'resource'= $Local:armResource
            'client_id' = $Local:clientID
            'grant_type' = 'client_credentials'
            'client_secret' = $Local:clientSecret
    }
    
    $params = @{
        ContentType = 'application/x-www-form-urlencoded'
        Headers = @{'accept'='application/json'}
        Body = $Local:body
        Method = 'POST'
        URI = $Local:tokenEndpoint
    }
    
    $token = Invoke-RestMethod @params -ErrorAction Stop `
             | Select-Object -ExpandProperty $Local:outputProjection
    
    return $Local:token
}

#
# DEPLOYMENT
#    

function DeployAResourceGroup() 
{
    <#
        .SYNOPSIS
          Create a container for the ARM resources.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the resource group to be created"
        )]
        [string]
        $resourceGroupName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the location of the resource group where has to be created"
        )]
        [string]
        $resourceGroupLocation,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the set of tags to be given to the resource group"
        )]
        [hashtable]
        $tags
    )

    $resourceGroup = Get-AzureRmResourceGroup -Name $Local:resourceGroupName `
                                              -ErrorAction SilentlyContinue
    if(!$resourceGroup)
    {
        $message="Creating resource group '$Local:resourceGroupName' in `
                  location '$Local:resourceGroupLocation'"
        PrintOutputMessage $message
        New-AzureRmResourceGroup -Name "$Local:resourceGroupName" `
                                 -Location "$Local:resourceGroupLocation" `
                                 -Tag $Local:tags `
                                 -Force
    } else {
        PrintOutputMessage "Using existing resource group '$Local:resourceGroupName'"
    }
    return $resourceGroup
}


function ExistsTheDeployment() 
{
    <#
        .SYNOPSIS
            Check if a given deployment exists.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the resource group to be checked"
        )]
        [string]
        $resourceGroupName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the deployment to be checked"
        )]
        [string]
        $deploymentName 
    )

    $currentDeployment = Get-AzureRmResourceGroupDeployment `
                                -ResourceGroupName $Local:resourceGroupName `
                                -Name $Local:deploymentName `
                                -ErrorAction SilentlyContinue

    if($Local:currentDeployment) 
    {
        try
        {
             Remove-AzureRmResourceGroupDeployment `
                    -ResourceGroupName $Local:resourceGroupName `
                    -Name $Local:deploymentName
             
             return $True 
        } 
        catch 
        {
             PrintOutputMessage "Deletion of $Local:deploymentName failed."   
        }
    }

    return $False
}

function DeployANewTemplate() 
{
    <#
        .SYNOPSIS
           Create a new ARM deployment.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the resource group to be created or updated"
        )]
        [string]
        $resourceGroupName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the deployment to be deployed"
        )]
        [string]
        $deploymentName,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the address of the deployment template. It must be publicly accessable"
        )]
        [string]
        $templateFileUri,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the address of the parameters template file. It must be publicly accessable"
        )]
        [string]
        $parametersFileUri
    )

    $deploymentAlreadyExists =  ExistsTheDeployment $Local:resourceGroupName `
                                                    $Local:deploymentName

    if($Local:deploymentAlreadyExists) 
    {
        PrintOutputMessage "The deployment $Local:deploymentName already exists."
        PrintOutputMessage "It will be updated through deletion."
    } 
    else 
    {
        PrintOutputMessage "The deployment $Local:deploymentName does not exist."
        PrintOutputMessage "It will be created."
    }

    $deploymentTest=Test-AzureRmResourceGroupDeployment `
                    -ResourceGroupName "$Local:resourceGroupName" `
                    -TemplateUri "$Local:templateFileUri" `
                    -TemplateParameterUri "$Local:parametersFileUri" `
                    -Mode Incremental

    if(!$Local:deploymentTest) 
    {
        $deploymentStatus=New-AzureRmResourceGroupDeployment `
                            -ResourceGroupName "$Local:resourceGroupName" `
                            -Name "$Local:deploymentName" `
                            -TemplateUri "$Local:templateFileUri" `
                            -TemplateParameterUri "$Local:parametersFileUri" `
                            -Mode Incremental

        PrintOutputMessage "The deployment is finished. Received the following object $deploymentStatus." 
    } 
    else 
    {
        PrintOutputMessage "The deployment template is not valid."
        PrintOutputMessage "The execution will be stopped."
        PrintOutputMessage $Local:deploymentTest
        PrintHowToGetAzureRMLogs
        Exit 1
    }
}


function ExistsPolicyDefinition() 
{
    <#
        .SYNOPSIS
             Verify the existance of a given policy definition by name. 
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the policy definition to be checked"
        )]
        [string]
        $policyDefinitionName,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the Azure Account subscriptionId"
        )]
        [string]
        $subscriptionId,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the bearer access token"
        )]
        [string]
        $bearerAccessToken
    )

    $uriTemplate="https://management.azure.com/subscriptions/" `
                 + $Local:subscriptionId `
                 + "/providers/Microsoft.Authorization/policyDefinitions/" `
                 + "$Local:policyDefinitionName" `
                 + "?api-version=" `
                 + $Script:policyDefinitionApiVersion

    $params = @{
            Headers = @{"Authorization" = "Bearer $Local:bearerAccessToken"}
            Method = 'GET'
            URI = $Local:uriTemplate
        }

    $requestResponse=Invoke-WebRequest @params
    
    if($Lcoal:requestResponse.StatusCode -eq '200')
    {
            PrintOutputMessage "The Policy $policyDefinitionName already exists"
            return $True
    }
    else 
    {
            PrintOutputMessage "The Policy $policyDefinitionName does not exists"
            return $False
    }  
}

function DeletePolicyDefinition() 
{
    <#
        .SYNOPSIS
             Delete a policy definition.
        .NOTES
             In case the poliy definition is used in any policy assignment.
             ARM will get an Error message. Try to delete all its assignments,
             and then retry. 
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the policy definition to be deleted"
        )]
        [string]
        $policyDefinitionName,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the Azure Account subscriptionId"
        )]
        [string]
        $subscriptionId,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the bearer access token"
        )]
        [string]
        $bearerAccessToken
    )

    $uriTemplate="https://management.azure.com/subscriptions/" `
                 + $Local:subscriptionId `
                 + "/providers/Microsoft.Authorization/policyDefinitions/" `
                 + "$Local:policyDefinitionName" `
                 + "?api-version=" `
                 + $Script:policyDefinitionApiVersion

    $params = @{
            Headers = @{"Authorization" = "Bearer $bearerAccessToken"}
            Method = 'DELETE'
            URI = $Local:uriTemplate
        }

    $requestResponse=Invoke-WebRequest @params

    if($requestResponse.StatusCode -eq '200')
    {
        PrintOutputMessage "Deleted the Policy $policyDefinitionName"
        return $True
    }

    if($requestResponse.StatusCode -eq '204')
    {
        PrintOutputMessage "The Policy $policyDefinitionName does not exists"
        return $False
    }
    
}

function CreateOrUpdatePolicyDefinition() 
{
    <#
        .SYNOPSIS
             Create or update a policy definition by name.  
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the policy definition to be created"
        )]
        [string]
        $policyDefinitionName,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the display name for the policy definition to be created"
        )]
        [string]
        $policyDefinitionDisplayName,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the description for the policy definition to be created"
        )]
        [string]
        $policyDefinitionDescription,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the complete URI where the policy definition is stored"
        )]
        [string]
        $policyDefinitionUri,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the Azure Account subscriptionId"
        )]
        [string]
        $subscriptionId,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the bearer access token"
        )]
        [string]
        $bearerAccessToken
    )        
    $uriTemplate="https://management.azure.com/subscriptions/" `
                 + $Local:subscriptionId `
                 + "/providers/Microsoft.Authorization/policyDefinitions/" `
                 + $Local:policyDefinitionName `
                 + "?api-version=" `
                 + $Script:policyDefinitionApiVersion

    $policyDefinitionContent=Invoke-WebRequest $Local:policyDefinitionUri `
                             | Select-Object -ExpandProperty Content

    $body=@"
        {  
            "properties": {   
                "displayName": "$Local:policyDefinitionDisplayName",
                "description": "$Local:policyDefinitionDescription",
                "mode": "All",
                "policyRule": $Local:policyDefinitionContent,
                "policyType": "Custom"
             }  
        }
"@

    $params = @{
            ContentType = 'application/json'
            Headers = @{"Authorization"="Bearer $Local:bearerAccessToken"}
            Body = $body
            Method = 'PUT'
            URI = $Local:uriTemplate
        }

    $requestResponse=Invoke-WebRequest @params
    PrintOutputMessage "$Local:requestResponse.Content"
     
    if($Local:requestResponse.StatusCode -eq '201')
    {
        PrintOutputMessage "The Policy Definition $policyDefinitionName created"
        return $True
    }
    return $False
}


function GetPolicyDefinitionId() 
{
    <#
        .SYNOPSIS
           Given a policy definition name retrieve its Id from ARM.
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name for the policy definition to be used"
        )]
        [string]
        $policyDefinitionName,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the Azure Account subscriptionId"
        )]
        [string]
        $subscriptionId,
        
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the bearer access token"
        )]
        [string]
        $bearerAccessToken
    )

    $uriTemplate="https://management.azure.com/subscriptions/" `
                 + $Local:subscriptionId `
                 + "/providers/Microsoft.Authorization/policyDefinitions/" `
                 + $Local:policyDefinitionName `
                 + "?api-version=" `
                 + $Script:policyDefinitionApiVersion
    $params = @{
        Headers = @{"Authorization" = "Bearer $Local:bearerAccessToken"}
        Method = 'GET'
        URI = $Local:uriTemplate
    }
    
    try 
    {
        $requestResponse=Invoke-RestMethod @params
        return ( $Local:requestResponse | Select-Object -ExpandProperty id )
    }
    catch
    {
           Write-Error "GetPolicyDefinitionId() failed"
           return  
    }
    
    
}

function DeleteByIdPolicyAssignment()
{
    <#
        .SYNOPSIS
             Given a PolicyAssignment Id delete it.   
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the policy assignment URI"
        )]
        [string]
        $policyUri,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert bearer access token"
        )]
        [string]
        $bearerAccessToken
    )

    try 
    {
        Invoke-WebRequest -Uri $policyUri `
                          -Method 'DELETE' `
                          -Headers @{"Authorization"="Bearer $bearerAccessToken"}
        return $True
    }
    catch
    {
        Write-Error "DeleteByIdPolicyAssignment() failed"
        return $False
    }
}

function CreateOrUpdatePolicyAssignment() 
{
    <#
        .SYNOPSIS
             Given a PolicyDefinition assign it to a ResourceGroup.   
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name of the policy assignment"
        )]
        [string]
        $policyAssignmentName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the display name for the policy assignment"
        )]
        [string]
        $policyAssignmentDisplayName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the description for the policy assignment"
        )]
        [string]
        $policyAssignmentDescription,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name for the policy definition to be used"
        )]
        [string]
        $policyDefinitionName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the name for the resource group to be used"
        )]
        [string]
        $resourceGroupName,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the Azure Account subscriptionId"
        )]
        [string]
        $subscriptionId,

        [Parameter(
            Mandatory=$True,
            HelpMessage="Please, insert the bearer access token"
        )]
        [string]
        $bearerAccessToken
    )

    $scope="/subscriptions/" `
           + $Local:subscriptionId `
           + "/resourceGroups/" `
           + $Local:resourceGroupName

    $uriTemplate="https://management.azure.com/" `
                 + $Local:scope `
                 + "/providers/Microsoft.Authorization/policyAssignments/" `
                 + $Local:policyAssignmentName `
                 + "?api-version=" `
                 + $Script:policyDefinitionApiVersion

    $policyDefinitionId=GetPolicyDefinitionId $Local:policyDefinitionName `
                                              $Local:subscriptionId `
                                              $Local:bearerAccessToken

    if(isNotNull $Local:policyDefinitionId) {
        $body=@"
        {
            "properties": {
              "displayName": "$Local:policyAssignmentDisplayName",
              "description": "$Local:policyAssignmentDescription",
              "policyDefinitionId": "$Local:policyDefinitionId"
            }
        }
"@

        $params = @{
                ContentType = 'application/json'
                Headers = @{"Authorization"="Bearer $bearerAccessToken"}
                Body = $body
                Method = 'PUT'
                URI = $Local:uriTemplate
            }

        try
        {       
                 if(DeleteByIdPolicyAssignment "$Local:uriTemplate" `
                                               "$Local:bearerAccessToken")
                 {  
                    $response=Invoke-RestMethod @params
                    PrintOutputMessage "$Local:response"
                    return $True
                 }
        } 
        catch 
        {
            Write-Error "CreateOrUpdatePolicyAssignment() failed: $_.Exception.Response.StatusCode.value__"
        }     
    }
    return $False
}

function ScriptArgumentsAreOk()
{       
        <#
            .SYNOPSIS
                 Validate if all script variables are defined and initialized. 
        #>    
        [CmdletBinding()]
        param(
            [Parameter(
                Mandatory=$True,
                HelpMessage="Please, insert the Azure Account {{subscriptionId}}"
            )]
            [string]
            $subscriptionId
        )

        $mandatoryParametersAreOk = checkInput $Script:resourceGroupName `
                                               $Script:resourceGroupLocation `
                                               $Script:deploymentName  
        if (!$Local:mandatoryParametersAreOk) {
            PrintOutputMessage "Some of mandatory variables are undefined for some reason."
            PrintOutputMessage "Check them and retry the action."
            return $False
        }

        $urisAreOk = checkInput $Script:templateFileUri `
                                $Script:parametersFileUri `
                                $Script:policyDefinitionUri         
        if (!$Local:urisAreOk) {
            PrintOutputMessage "Some of URIs links are undefined for some reason."
            PrintOutputMessage "Check them and retry the action."
            return $False
        }

        $tagsAreOk = isNotNull $Script:tags
        if (!$Local:tagsAreOk) {
            PrintOutputMessage "The '$tags' parameter results not defined."
            PrintOutputMessage "Check it and retry the action."
            return $False
        }

        $policyDefinitionParametersAreOk = checkInput $Script:policyDefinitionName `
                                                      $Script:policyDefinitionDisplayName `
                                                      $Script:policyDefinitionDescription
        if (!$policyDefinitionParametersAreOk) {
            PrintOutputMessage "Some PolicyDefinition parameters are not defined."
            PrintOutputMessage "Check them and retry the action."
            return $False
        }

        $policyAssignmentParametersAreOk = checkInput $Script:policyAssignmentName `
                                                      $Script:policyAssignmentDisplayName `
                                                      $Script:policyAssignmentDescription
        if(!$policyAssignmentParametersAreOk) {
            PrintOutputMessage "Some PolicyAssignement parameters are not defined."
            PrintOutputMessage "Check them and retry the action."
            return $False
        }

        $subscriptionAndpolicyUriParametersAreOk = checkInput $Local:subscriptionId `
                                                              $Script:policyDefinitionUri `
                                                              "Test"
        if(!$subscriptionAndpolicyUriParametersAreOk) {
            PrintOutputMessage "Check subscriptionId or policyDefinitionUri `
                                parameters. Possible null values."
            PrintOutputMessage "Check them and retry the action."
            return $False
        }

        return $True
} 

function Main() 
{
    <#
        .SYNOPSIS
             Deploy a resource group and a nested template in it. 
             Afer that define and assign a policy.  
    #>
    PrintOutputMessage ""
    PrintOutputMessage "Initializing script environment variables"
    PrintOutputMessage "Reading: Env:/ClientId, Env:/FirstKeyApp, Env:/TenantId, Env:ASID"
    
    $clientID       =   Get-Content Env:/ClientId
    $clientSecret   =   Get-Content Env:/FirstKeyApp
    $tenantId       =   Get-Content Env:/TenantId
    $subscriptionId =   Get-Content Env:/ASID

    PrintOutputMessage "The following Actor: $Local:clientID will create objects on behalf of TenantId: $Local:tenantId"
    
    $ok             =   LoginToAzureCloud $Local:clientSecret `
                                          $Local:clientID `
                                          $Local:tenantId
    $accessToken    =   GetBearerToken $Local:clientSecret `
                                       $Local:clientID `
                                       $Local:tenantId

    $isOkLoginAndAccessToken    =   (isNotNull $Local:accessToken) -and $ok
    
    $scriptParamsAreOk=ScriptArgumentsAreOk $Local:subscriptionId
         
    if ($Local:isOkLoginAndAccessToken -and $Local:scriptParamsAreOk) 
    {
        
            DeployAResourceGroup $Script:resourceGroupName `
                                 $Script:resourceGroupLocation `
                                 $Script:tags

            DeployANewTemplate $Script:resourceGroupName `
                               $Script:deploymentName `
                               $Script:templateFileUri `
                               $Script:parametersFileUri
            $policyDefinitionCreationOutput=CreateOrUpdatePolicyDefinition $Script:policyDefinitionName `
                                                                $Script:policyDefinitionDisplayName `
                                                                $Script:policyDefinitionDescription `
                                                                $Script:policyDefinitionUri `
                                                                $Local:subscriptionId `
                                                                $Local:accessToken
            PrintOutputMessage "$Local:policyDefinitionCreationOutput"
            if($Local:policyDefinitionCreationOutput)
            {
                $policyAssignmentOutput=CreateOrUpdatePolicyAssignment $Script:policyAssignmentName `
                                        $Script:policyAssignmentDisplayName `
                                        $Script:policyAssignmentDescription `
                                        $Script:policyDefinitionName `
                                        $Script:resourceGroupName `
                                        $Local:subscriptionId `
                                        $Local:accessToken
                

                PrintOutputMessage "All the deployment is completed. $Local:policyAssignmentOutput"
            } 
    } 
    else 
    {
        PrintOutputMessage "Some Azure account data is not initialized. Exiting."
        Exit 1
    }    
}

#******************************************************************************
# HERE STARTS THE EXECUTION
#******************************************************************************

Main






