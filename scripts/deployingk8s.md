Prequisites

1) Docker Desktop w/ k8s enabled
2) Install Azure CLI
3) Helm CLI     
# AKS Deployment

1) Create SSH Key
```
ssh-keygen -t rsa -b 2048
```
Note the location as you will need the public key in the next step. 
2) Deploy AKS:
Login using `az login` if you haven't already and make sure the correct subscription is set as default using `az account set`
``` bash
Create a resource group
az group create --name openamtk8s --location eastus
az deployment group create --resource-group openamtk8s --template-file aks.json
```
You will be prompted for a DNS Prefix which is used for the AKS cluster management API, the linux user admin name (i.e. your name)


3) Update Dependencies
```
helm dependency update
```
4) Ensure your kubectl is connected to the Kubernets cluster you wish to deploy/manage. With AKS, use the following: 

```
az aks get-credentials --resource-group openamtk8s --name aks101cluster
```

5) Create secrets 

Private Registry
```
kubectl create secret docker-registry registryCredentials --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword>
```

Vault Token:
```
kubectl create secret generic vault --from-literal=vaultKey=<your root token>
```


3) Update configuration/environment variables with desired FQDN


4) Deploy Open AMT Cloud Toolkit using Kubectl
```
kubectl create -f toolkit.yaml
```

Deploying using Helm
```
helm install 
```
