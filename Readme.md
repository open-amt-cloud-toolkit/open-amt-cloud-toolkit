# Open AMT Cloud Toolkit

> Disclaimer: Production viable releases are tagged and listed under 'Releases'. All other check-ins should be considered 'in-development' and should not be used in production

Open Active Management Technology Cloud Toolkit (Open AMT Cloud Toolkit) provides open-source, modular microservices and libraries for integration of Intel® Active Management Technology (Intel® AMT). As an open source implementation, the toolkit makes it easier for IT departments and independent software vendors (ISVs) to adopt, integrate, and customize Out-of-band Management (OOB Management) solutions for Intel vPro® Platforms.

<br>

**For detailed documentation** about the Open AMT Cloud Toolkit, see the [docs](https://open-amt-cloud-toolkit.github.io/docs).

<br>

## Clone

**Important!** Make sure you clone with this repo with the `--recursive` flag since it uses git submodules.
```
git clone --recursive https://github.com/open-amt-cloud-toolkit/open-amt-cloud-toolkit.git
```

<br>

## Get Started

### There are multiple options to quickly deploy the Open AMT Cloud Toolkit:

<br>

### Local using Docker
The quickest and easiest option is to set up a local stack using Docker*, view our [Documentation Site](https://open-amt-cloud-toolkit.github.io/docs/) and click the Getting Started tab for How-To steps and examples.

<br>

### Cloud using Azure
For more experienced users, deploy the stack on Azure using the 'Deploy to Azure' button below. Note: This requires MPS, RPS, and Sample Web UI images to be built and accessible in a Container Image Registry such as Azure Container Registry (ACR), Docker Hub, or other options.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fopen-amt-cloud-toolkit%2Fopen-amt-cloud-toolkit%2Fmain%2FazureDeploy.json)

Optionally, deploy from AzureCLI using the following commands:

``` bash
az group create --name openamt --location eastus
az deployment group create --resource-group openamt --template-file azureDeploy.json
```