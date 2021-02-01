:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

if "" == "%~1" (
echo usage: launchcluster.bat [resourceGroupName] [aksClusterName] [region] [servicePrincipal] [clientSecret]
EXIT /B 1
)

if "" == "%~2" (
echo usage: launchcluster.bat [resourceGroupName] [aksClusterName] [region] [servicePrincipal] [clientSecret]
EXIT /B 1
)

if "" == "%~3" (
echo usage: launchcluster.bat [resourceGroupName] [aksClusterName] [region] [servicePrincipal] [clientSecret]
EXIT /B 1
)

if "" == "%~4" (
echo usage: launchcluster.bat [resourceGroupName] [aksClusterName] [region] [servicePrincipal] [clientSecret]
EXIT /B 1
)

if "" == "%~5" (
echo usage: launchcluster.bat [resourceGroupName] [aksClusterName] [region] [servicePrincipal] [clientSecret]
EXIT /B 1
)

set myResourceGroup=%1
set myAksCluster=%2
set region=%3
set servicePrincipal=%4
set clientSecret=%5

call az account show && (
  echo account is already logged in
) || (
echo please log in with the browser
call az login && (
  echo login was successful
) || (
  echo login failed
  EXIT /B 1
)
)

call az group create --name %myResourceGroup% --location %region% && (
  echo resource group create was successful
) || (
  echo create failed
  EXIT /B 1
)

echo creating aks
call az aks create --resource-group %myResourceGroup% --name %myAksCluster% --node-count 3 --enable-addons monitoring --service-principal %servicePrincipal% --client-secret %clientSecret% --generate-ssh-keys && (
  echo create aks was successful
) || (
  echo create aks failed
  EXIT /B 1
)

call az aks get-credentials --resource-group %myResourceGroup% --name %myAksCluster% --overwrite-existing && (
  echo get-credentials was successful
) || (
  echo get-credentials failed
  EXIT /B 1
)

call kubectl get nodes && (
  echo get nodes was successful
) || (
  echo get nodes failed
  EXIT /B 1
)


echo ResourceGroup: %myResourceGroup%
echo aks cluster: %myAKSCluster%

@echo RESOURCEGROUP=%myResourceGroup% > .env
@echo AKS_CLUSTER=%myAKSCluster% >> .env