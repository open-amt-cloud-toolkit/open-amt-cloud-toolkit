#/*********************************************************************
# Copyright (c) Intel Corporation 2020
# SPDX-License-Identifier: Apache-2.0
#**********************************************************************/

myResourceGroup=$1
myAksCluster="$1-aks"
region=$2

echo $myResourceGroup
echo $myAksCluster
echo $region

az group create --name $myResourceGroup --location $region
if [ $? -eq 0 ]; then
    echo "Resource Group successfully created."
else
    echo "Resource Group creation failed. Exiting."
    exit 1
fi
az aks create --resource-group $myResourceGroup --name $myAksCluster --node-count 3 --enable-addons monitoring --generate-ssh-keys
if [ $? -eq 0 ]; then
    echo "AKS Cluster successfully created."
else
    echo "AKS Cluster creation failed. Exiting."
    exit 1
fi
az aks get-credentials --resource-group $myResourceGroup --name $myAksCluster
if [ $? -eq 0 ]; then
    echo "AKS Credentials retrieved successfully."
else
    echo "AKS Credentials failed. Exiting."
    exit 1
fi

