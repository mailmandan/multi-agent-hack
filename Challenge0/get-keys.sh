#!/bin/bash
#
# This script will retrieve necessary keys and properties from Azure Resources 
# and store them in a file named ".env" in the parent directory.

set -e  # Exit on error

# Function to check command status and output
check_command() {
    local result=$1
    local error_message=$2
    
    if [ -z "$result" ]; then
        echo "Error: $error_message - Empty response"
        exit 1
    fi
    echo "Retrieved: $result"
}

# Login to Azure
if [ -z "$(az account show 2>/dev/null)" ]; then
    echo "User not signed in Azure. Signin to Azure using 'az login' command."
    az login --use-device-code
fi

# Get the resource group name from parameter
resourceGroupName=""
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --resource-group) resourceGroupName="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if resourceGroupName is provided
if [ -z "$resourceGroupName" ]; then
    echo "Enter the resource group name where the resources are deployed:"
    read resourceGroupName
fi

# List resources in the resource group for debugging
echo "Resources in resource group $resourceGroupName:"
az resource list --resource-group "$resourceGroupName" --output table

# Find CosmosDB account
echo "Finding CosmosDB account..."
cosmosdbAccountName=$(az resource list --resource-group "$resourceGroupName" \
    --resource-type "Microsoft.DocumentDB/databaseAccounts" \
    --query '[0].name' -o tsv)
check_command "$cosmosdbAccountName" "No CosmosDB account found"
echo "Found CosmosDB account: $cosmosdbAccountName"

# Find Cognitive Services account (OpenAI)
echo "Finding Azure OpenAI service..."
openaiServiceName=$(az resource list --resource-group "$resourceGroupName" \
    --resource-type "Microsoft.CognitiveServices/accounts" \
    --query "[?kind=='OpenAI'].name" -o tsv)
check_command "$openaiServiceName" "No Azure OpenAI service found"
echo "Found Azure OpenAI service: $openaiServiceName"

# Find Application Insights
echo "Finding Application Insights..."
appInsightsName=$(az resource list --resource-group "$resourceGroupName" \
    --resource-type "Microsoft.Insights/components" \
    --query '[0].name' -o tsv)
check_command "$appInsightsName" "No Application Insights found"
echo "Found Application Insights: $appInsightsName"

# Get resource details and keys
echo "Getting resource details and keys..."

# CosmosDB details
echo "Retrieving CosmosDB endpoint..."
cosmosdbEndpoint=$(az cosmosdb show --name "$cosmosdbAccountName" \
    --resource-group "$resourceGroupName" \
    --query "documentEndpoint" -o tsv)
check_command "$cosmosdbEndpoint" "Failed to get CosmosDB endpoint"

echo "Retrieving CosmosDB key..."
cosmosdbKey=$(az cosmosdb keys list --name "$cosmosdbAccountName" \
    --resource-group "$resourceGroupName" \
    --query "primaryMasterKey" -o tsv)
check_command "$cosmosdbKey" "Failed to get CosmosDB key"

# OpenAI details
echo "Retrieving OpenAI endpoint..."
openaiEndpoint=$(az cognitiveservices account show --name "$openaiServiceName" \
    --resource-group "$resourceGroupName" \
    --query "properties.endpoint" -o tsv)
check_command "$openaiEndpoint" "Failed to get OpenAI endpoint"

echo "Retrieving OpenAI key..."
openaiKey=$(az cognitiveservices account keys list --name "$openaiServiceName" \
    --resource-group "$resourceGroupName" \
    --query "key1" -o tsv)
check_command "$openaiKey" "Failed to get OpenAI key"

# Check and install Application Insights extension if needed
echo "Checking for Application Insights extension..."
if ! az extension show --name application-insights >/dev/null 2>&1; then
    echo "Installing application-insights extension..."
    az extension add --name application-insights --only-show-errors
fi

# Application Insights key
echo "Debug: Application Insights name = $appInsightsName"
echo "Debug: Resource group = $resourceGroupName"
echo "Retrieving Application Insights key..."

# Get Application Insights key
appInsightsKey=$(az monitor app-insights component show \
    --app "$appInsightsName" \
    --resource-group "$resourceGroupName" \
    --query "instrumentationKey" -o tsv)
check_command "$appInsightsKey" "Failed to get Application Insights key"

# Create .env file with progress indication
echo "Creating .env file..."
cat > ../.env << EOF
COSMOS_ENDPOINT="${cosmosdbEndpoint}"
COSMOSDB_DATABASE="autogen"
COSMOSDB_CONTAINER="memory"
COSMOS_KEY="${cosmosdbKey}"
AZURE_OPENAI_ENDPOINT="${openaiEndpoint}"
AZURE_OPENAI_KEY="${openaiKey}"
AZURE_OPENAI_MODEL_NAME="gpt-4o"
AZURE_OPENAI_DEPLOYMENT_NAME="gpt-4o"
AZURE_OPENAI_API_VERSION="2024-08-01-preview"
APPLICATIONINSIGHTS_INSTRUMENTATION_KEY="${appInsightsKey}"
BACKEND_API_URL="http://localhost:8000"
FRONTEND_SITE_NAME="http://127.0.0.1:3000"
EOF

# Verify the .env file was created with content
if [ ! -s ../.env ]; then
    echo "Error: .env file is empty or was not created"
    exit 1
fi

# Add this after verifying the .env file and before the final success message
if [ -f tmp_outputs.json ]; then
    rm tmp_outputs.json
fi

echo "Keys and properties have been stored in ../.env file successfully."