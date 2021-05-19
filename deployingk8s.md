Prerequisites

- Docker Desktop w/ kubectl
- Azure CLI
- Helm CLI     

# AKS Deployment

1) Create SSH Key
```
ssh-keygen -t rsa -b 2048
```
Note the location as you will need the public key in the next step. 

2) Deploy AKS

Login using `az login` if you haven't already and make sure the correct subscription is set as default using `az account set`
``` bash
az group create --name <your-resource-group-name> --location eastus
az deployment group create --resource-group <your-resource-group-name> --template-file aks.json
```
You will be prompted for a name for the AKS Cluster, the linux user admin name (i.e. your name), and the public key you generated in step 1. This takes about ~5 min. Note the `fqdnSuffix` in the "outputs" section of the JSON response (i.e. westus2.cloudapp.azure.com) when complete. This will be needed for the updating the commonName in the `values.yaml` file.

3) Ensure your `kubectl` is connected to the Kubernetes cluster you wish to deploy/manage. With AKS, use the following: 

```
az aks get-credentials --resource-group <your-resource-group-name> --name <your-cluster-name>
```

4) Create secrets 

If you are using a private docker registry, you'll need to provide your credentials to K8S. 
```
kubectl create secret docker-registry registrycredentials --docker-server=<your-registry-server> --docker-username=<your-username> --docker-password=<your-password>
```


5) Update the `kong:` section in the `values.yaml` file with the desired dns name you would like for your cluster (i.e. myopenamtk8s):

``` yaml
kong:
  proxy:
    annotations:
      service.beta.kubernetes.io/azure-dns-label-name: "<your-domain-name>"
```

Next, update the `commonName:` key in the `mps:` section in the `values.yaml` file with the FQDN for your cluster. For AKS, the format is `<your-domain-name>.<location>.cloudapp.azure.com`. This is value provided in the "outputs" section in step 2.

``` yaml
mps:
  commonName: "<your-domain-name>.<location>.cloudapp.azure.com"
```

6) Deploy Open AMT Cloud Toolkit using Helm

Deploying using Helm
```
helm install openamtstack ./charts
```

7) Initialize and Unseal Vault

Use the following instructions to initialize unseal and vault: 

8) Once you have your vault token, we'll add the root token as a secret to the k8s cluster so the services can access it.

Vault Token:
```
kubectl create secret generic vault --from-literal=vaultKey=s.nGxX5HLFxnto4oGfyygyCHY9
```


