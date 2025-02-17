
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmartaldsantos%2Fmulti-agent-hack%2Fmain%2Fazuredeploy.json)## Challenge 0 - Enviornment Creation and Resources Deployment

**Expected Duration:** 30 minutes

## Introduction
Your goal in this challenge is to create the services necessary to conduct this hackathon. You will deploy the required resources in Azure, including the Azure AI services that will be used in the subsequent challenges. By completing this challenge, you will set up the foundation for the rest of the hackathon.

## Step 1 -  Clone the Repository

Before you start, please fork this repository to your GitHub account by clicking the `Fork` button in the upper right corner of the repository's main screen (or follow the [documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository)). This will allow you to make changes to the repository and save your progress.

## Step 2 -  Azure Resources Deployment

The first step on this hackathon will be to create the resources we will use throughout the day. Clicking on button bellow will redirect you to the Azure portal to deploy the resources using the [ARM template](iac) provided in this repository.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmartaldsantos%2Fmulti-agent-hack%2Fmain%2FChallenge0%2Fdeploy%2Fmacae-continer.bicep)

**NOTE:** Deployment may fail if the resource provider `Microsoft.AlertsManagement` is not registered in your. Follow the [documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider-1) to register it and the re-run the deployment.

**NOTE:** If you encounter an error downloading the template from the URI, ensure that the template is publicly accessible and that the publisher has enabled CORS policy on the endpoint. To deploy this template, download the template manually and paste the contents in the 'Build your own template in the editor' option below.

Resource deployment can take up to 5 minutes. Once the deployment is complete, you will see the resources in your Azure portal.

In the meantime, you can proceed with the step nº3 - opening pre-configured development environment in GitHub Codespaces.

## Step 3 -  Azure Resources Deployment

GitHub Codespaces is a cloud-based development environment that allows you to code from anywhere. It provides a fully configured environment that can be launched directly from any GitHub repository, saving you from lengthy setup times. You can access Codespaces from your browser, Visual Studio Code, or the GitHub CLI, making it easy to work from virtually any device.

To open GitHub Codespaces, click on the button below:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/)

Please select your forked repository from the dropdown and, if necessary, adjust other settings of GitHub Codespace.

**NOTE:** If GitHub Codespaces is not enabled in your organization, you can enable it by following the instructions [here](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/enabling-or-disabling-github-codespaces-for-your-organization), or, if you cannot change your GitHub organization's settings, create free personal GitHub account [here](https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home).


## Step 4 - Set Up Authentication in Azure App Service

1. Click on `Authentication` from left menu.

![Authentication](./images/azure-app-service-auth-setup/AppAuthentication.png)

2. Click on `+ Add Provider` to see a list of identity providers.

![Authentication Identity](./images/azure-app-service-auth-setup/AppAuthenticationIdentity.png)

3. Click on `+ Add Provider` to see a list of identity providers.

![Add Provider](./images/azure-app-service-auth-setup/AppAuthIdentityProvider.png)

4. Select the first option `Microsoft Entra Id` from the drop-down list. If `Create new app registration` is disabled, go to [Step 1a](#step-1a-creating-a-new-app-registration).

![Add Provider](./images/azure-app-service-auth-setup/AppAuthIdentityProviderAdd.png)

5. Accept the default values and click on `Add` button to go back to the previous page with the idenity provider added.

![Add Provider](./images/azure-app-service-auth-setup/AppAuthIdentityProviderAdded.png)

### Step 1a: Creating a new App Registration

1. Click on `Home` and select `Microsoft Entra ID`.

![Microsoft Entra ID](./images/azure-app-service-auth-setup/MicrosoftEntraID.png)

2. Click on `App registrations`.

![App registrations](./images/azure-app-service-auth-setup/Appregistrations.png)

3. Click on `+ New registration`.

![New Registrations](./images/azure-app-service-auth-setup/NewRegistration.png)

4. Provide the `Name`, select supported account types as `Accounts in this organizational directory only(Contoso only - Single tenant)`, select platform as `Web`, enter/select the `URL` and register.

![Add Details](./images/azure-app-service-auth-setup/AddDetails.png)

5. After application is created sucessfully, then click on `Add a Redirect URL`.

![Redirect URL](./images/azure-app-service-auth-setup/AddRedirectURL.png)

6. Click on `+ Add a platform`.

![+ Add platform](./images/azure-app-service-auth-setup/AddPlatform.png)

7. Click on `Web`.

![Web](./images/azure-app-service-auth-setup/Web.png)

8. Enter the `web app URL` (Provide the app service name in place of XXXX) and Save. Then go back to [Step 1](#step-1-add-authentication-in-azure-app-service-configuration) and follow from _Point 4_ choose `Pick an existing app registration in this directory` from the Add an Identity Provider page and provide the newly registered App Name.
E.g. https://appservicename.azurewebsites.net/.auth/login/aad/callback

![Add Details](./images/azure-app-service-auth-setup/WebAppURL.png)



## Step 5 -  Enviornment Confirmation
Go back to your `Azure Portal` and find your `Resource Group`that should by now contain 7 resources.

After deploying the resources, you will need to configure the environment variables in the `.env` file. The `.env` file is a configuration file that contains the environment variables for the application. The `.env` file is automatically created running the following command within the terminal in your Codespace:

```bash
cd challenge0
./get-keys.sh --resource-group <resource-group-name>
```

If needed run `chmod u+rx get-keys.sh` before the get keys script with the resource group.
 

This script will connect to Azure and fetch the necessary keys and populate the `.env` file with the required values in the root directory of the repository. If needed, script will prompt you to sign in to your Azure account.

When the script is finished, review the `.env` file to ensure that all the values are correct. If you need to make any changes, you can do so manually.


## Conclusion
By reaching this section you should have every resource and installed the requirements necessary to conduct the hackathon. You have deployed an Azure AI Document Intelligence service, an Azure Cosmos DB account, an Azure Storage Account and Azure OpenAI Service.

In the next challenges, you will use these services to build a strong document processing workflow.