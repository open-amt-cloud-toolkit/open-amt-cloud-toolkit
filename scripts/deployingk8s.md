Prequisites

1) Docker Desktop w/ k8s enabled
2) Install Azure CLI

# AKS Deployment

1) Create SSH Key
```
ssh-keygen -t rsa -b 2048
```
2) Deploy AKS:
``` bash
az group create --name openamtk8s --location eastus
az deployment group create --resource-group openamtk8s --template-file aks.json
```

3) Update Dependencies
```
helm dependency update
```

4) Create secrets 

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
