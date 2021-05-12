# AKS Deployment

1) Deploy AKS:
``` bash
az group create --name openamtk8s --location eastus
az deployment group create --resource-group openamtk8s --template-file aks.json
```

2) Create secrets 

### for accessing your private registry 
```
kubectl create secret docker-registry registryCredentials --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword>
```



3) Update configuration/environment variables with desired FQDN


4) Deploy Open AMT Cloud Toolkit
```
kubectl create -f toolkit.yaml
```

