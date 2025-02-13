# The Future of AI Design: Unlocking Multi-Agent Capabilities with Azure

Agentic AI systems have the potential to transform the way businesses operate, but building an MVP to demonstrate this value can be challenging. 🚀 This guide will walk you through the key components of multi-agent systems, and provide you with an Accelerator featuring a ready-to-go application. Whether you use it as the foundation for your MVP or as a reference, this will help you hit the ground running and fast-track your development. ⚡️

## Features
This accelerator demonstrates the following concepts and how to implement them:

- 

## Getting Started

### Prerequisites
To successfully complete this hackathon, you will need the following:

1. GitHub account to access the repository and run [GitHub Codespaces](https://github.com/features/codespaces).
2. Familiarity with Python programming, including making API calls.
3. The user deploying the template must have permission to create resources and resource groups.
4. Ability to provision Azure Container Application, Azure OpenAI and Azure Cosmos DB resources.

To start this hackathon, please follow the guidelines starting from Lab 0 through Lab 3, or automatically jump to the Lab 2 for implementation of the Multi-Agent Accelerator.

### Deploying Azure OpenAI supported regions

This template uses gpt-4o, dalle3 and text-embedding-3-large models by default using the Sweden Central region. If this region is not your preferred, please consider the models may not be available in all Azure regions. Check for [up-to-date region availability](https://learn.microsoft.com/azure/ai-services/openai/concepts/models) and select a region during deployment accordingly.


### Checking Azure OpenAI quota limits

For this sample to deploy successfully, there needs to be enough Azure OpenAI quota for the models used by this sample within your subscription. This sample deploys a new Azure OpenAI account with two models, **gpt-4o with 10K tokens** per minute and **text-3-large with 5k tokens** per minute. For more information on how to check your model quota and change it, see [Manage Azure OpenAI Service Quota](https://learn.microsoft.com/azure/ai-services/openai/how-to/quota)

### Azure Subscription Permission Requirements

This solution deploys [user-assigned managed identities](https://learn.microsoft.com/entra/identity/managed-identities-azure-resources/overview) and defines then applies Azure Cosmos DB RBAC permissions to this identity. At a minimum you will need the following Azure RBAC roles assigned to your identity in your Azure subscription or [Subscription Owner](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/privileged#owner) access which will give you both of the following.

- [Manged Identity Contributor](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/identity#managed-identity-contributor)
- [DocumentDB Account Contributor](https://learn.microsoft.com/azure/role-based-access-control/built-in-roles/databases#documentdb-account-contributor)

### Full-Text & Hybrid Search Feature

Full-text and hybrid search in Azure Cosmos DB is in Preview and only available to a subset of regions at this time. This feature is commented out in the GetChatCompletionAsync() function in the ChatService. To use this feature you must deploy this sample in either `northcentralus` or `uksouth`.


## Challenges

**Challenge 0: [Deployment of Resources in Azure](Challenge0/readme.md)**
Deploy and configure the necessary Azure resources, including the AI services that will be used throughout the hackathon, ensuring a solid foundation for the upcoming tasks and enabling seamless execution of the subsequent challenges.

**Challenge 1:  [Building your first Multi-Agent](Challenge1/readme.md)**
A step-by-step guide on creating your own Travel Agency Agents: create a team composed of several planners, guides and marketing professionals to create a personalized travel with tailored itineraries, local guidance, whilst delivering enriched content to your customers.


**Challenge 2:  [Expand Your Multi-Agent Capabilities](Challenge2/readme.md)**

**Challenge 3: [Advancing Real-World Applications](Challenge3/readme.md)**


Each challenge comes with its own set of tasks and objectives. Feel free to explore the challenges, learn, and have fun during this hackathon! If you have any questions, don't hesitate to reach out to your coach.

## Costs

You can estimate the cost of this project's architecture with [Azure's pricing calculator](https://azure.microsoft.com/pricing/calculator/)

As an example in $USD, here's how a sample MVP would be  currently built:

Average Monthly Cost:
* Azure Cosmos DB Serverless ($0.25 USD per 1M RU/s): $0.25
* Azure App Service (B1 Plan): $12.41
* Azure OpenAI (GPT-4o 1M input/output tokens): $20 (Sample uses 10K tokens)
* Azure OpenAI (text-3-large): < $0.01 (Sample uses 5K tokens)

## ⚠️ Important Security Notice

This template, the application code and configuration it contains, has been built to showcase Microsoft Azure specific services and tools. We strongly advise our customers not to make this code part of their production environments without implementing or enabling additional security features.


Happy hacking! 

