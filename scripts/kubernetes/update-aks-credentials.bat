:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

@echo off 

if "" == "%~1" (
echo usage: update-aks-credentials.bat [myResourceGroup]
EXIT /B 1
)

call az aks show --resource-group %1 --name %1-aks --query servicePrincipalProfile.clientId -o tsv > temp && (
      echo "Successfully obtained SP ID"
    ) || (
      echo "Failed to get SP ID"
    )
set /p SP_ID=<temp

call az ad sp credential reset --name %SP_ID% --query password -o tsv > temp && (
  echo "Successfully obtained SP Secret"
) || (
  echo "Failed to get SP Secret"
)
set /p SP_SECRET=<temp

echo "Sleep for 300 secs. For the credentials to get updated. "
timeout 300
echo "Update credentials"
call az aks update-credentials --resource-group %1 --name %1-aks --reset-service-principal --service-principal %SP_ID% --client-secret %SP_SECRET% && (
  echo update successful
) || (
  echo update failed
)

del temp