#/*********************************************************************
# Copyright (c) Intel Corporation 2020
# SPDX-License-Identifier: Apache-2.0
#**********************************************************************/
myResourceGroup=$1
myAKSCluster=$2
pfxPassword=$3

nodeResourceGroup=$(az aks show \
  --resource-group $myResourceGroup \
  --name $myAKSCluster \
  --query nodeResourceGroup \
  -o tsv)
echo $nodeResourceGroup
mps_ip=$(az network public-ip create \
    --resource-group $nodeResourceGroup \
    --name mpsip \
    --sku Standard \
    --allocation-method static)
echo $mps_ip
rps_ip=$(az network public-ip create \
    --resource-group $nodeResourceGroup \
    --name rpsip \
    --sku Standard \
    --allocation-method static)
echo $rps_ip
mps_ip_address=$(az network public-ip show --resource-group $nodeResourceGroup --name mpsip --query ipAddress --output tsv)
rps_ip_address=$(az network public-ip show --resource-group $nodeResourceGroup --name rpsip --query ipAddress --output tsv)

echo "MPS IP ADDRESS $mps_ip_address"
echo "RPS IP ADDRESS $rps_ip_address"
echo "Node Resource Group" $nodeResourceGroup

./gencerts.sh $mps_ip_address $rps_ip_address $pfxPassword