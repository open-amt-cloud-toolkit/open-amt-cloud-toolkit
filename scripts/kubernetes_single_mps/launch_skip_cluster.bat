:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

if "" == "%~1" (
echo usage: launch_skip_cluster.bat [resourceGroupName] [region]
EXIT /B 1
)

if "" == "%~2" (
echo usage: launch_skip_cluster.bat [resourceGroupName] [region]
EXIT /B 1
)

set Resource_group=%1
set region=%2
set aks_cluster=%Resource_group%-aks
set pfxPassword=Passw@rd123!

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO admin rights found! 
) ELSE (
    ECHO must be ran as an admin!
    EXIT /B 1
)


@echo RESOURCEGROUP=%Resource_group% > .env
@echo AKS_CLUSTER=%aks_cluster% >> .env

call createipsandcerts.bat %Resource_group% %aks_cluster% %pfxPassword%  && (
  echo createipsandcerts was successful
) || (
  echo createipsandcerts failed
  EXIT /B 1
)

call installvault.bat  && (
  echo installvaultwas successful
) || (
  echo installvault failed
  EXIT /B 1
)

call createsecrets.bat  && (
  echo createsecrets was successful
) || (
  echo createsecrets failed
  EXIT /B 1
)

node updatevalues.js && (
  echo updated helm values file successful
) || (
  echo updated helm values file failed
  EXIT /B 1
)

helm install openamtcloudstack ./serversChart && (
  echo deployment successful
) || (
  echo deployment failed
  EXIT /B 1
)