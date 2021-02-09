#/*********************************************************************
# Copyright (c) Intel Corporation 2020
# SPDX-License-Identifier: Apache-2.0
#**********************************************************************/

SP_ID=$(az aks show --resource-group $1 --name "$1-aks" \
    --query servicePrincipalProfile.clientId -o tsv)
SP_SECRET=$(az ad sp credential reset --name $SP_ID --query password -o tsv)
echo "Sleep for 300 secs for credentials to get updated."
sleep 300
echo "Run update-credentials.."
echo az aks update-credentials \
    --resource-group $1 \
    --name "$1-aks" \
    --reset-service-principal \
    --service-principal $SP_ID \
    --client-secret $SP_SECRET

az aks update-credentials \
    --resource-group $1 \
    --name "$1-aks" \
    --reset-service-principal \
    --service-principal $SP_ID \
    --client-secret $SP_SECRET
