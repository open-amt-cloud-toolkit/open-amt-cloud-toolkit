# AKS Deployment

1) Deploy AKS:
``` bash
az group create --name openamtk8s --location eastus
az deployment group create --resource-group openamtk8s --template-file aks.json
```

2) Create secret for accessing your private registry 
```
kubectl create secret docker-registry registryCredentials --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword>
```

3) Deploy Open AMT Cloud Toolkit
```
kubectrl create -f toolkit.yaml
```

