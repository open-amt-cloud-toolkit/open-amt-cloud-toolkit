# OpenAMT Cloud Toolkit

> Disclaimer: Production viable releases are tagged and listed under 'Releases'. All other check-ins should be considered 'in-development' and should not be used in production

## Clone

Important! Make sure you clone with this repo with the `--recursive` flag since it uses git submodules.
```
git clone --recursive https://github.com/open-amt-cloud-toolkit/open-amt-cloud-toolkit.git
```


[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fopen-amt-cloud-toolkit%2Fopen-amt-cloud-toolkit%2Fv1.2.0%2FazureDeploy.json)

Optionally, deploy from AzureCLI using the following commands:

``` bash
az group create --name openamt --location eastus
az deployment group create --resource-group openamt --template-file azureDeploy.json
```