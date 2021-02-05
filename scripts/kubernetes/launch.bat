:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

if "" == "%~1" (
echo usage: launch.bat [resourceGroupName]
EXIT /B 1
)


set Resource_group=%1
set region=westus2
set aks_cluster=%Resource_group%-aks
set pfxPassword=Passw@rd123!

set adminusername=admin
set adminpassword=Intel123!
set mpsapikey=APIKEYFORMPS123!
set mpspassword=Intel123!
set rpsapikey=APIKEYFORRPS123!
set sessionEncryptionKey=sessionEncryptionKey
set redisPassword=redisPassword!



NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO admin rights found! 
) ELSE (
    ECHO must be ran as an admin!
    EXIT /B 1
)

del .env

git checkout ./serversChart/values.yaml


call launchcluster.bat %Resource_group% %aks_cluster% %region% && (
  echo launchcluster was successful
) || (
  echo launchcluster failed
  EXIT /B 1
)

call createipsandcerts.bat %Resource_group% %aks_cluster% %pfxPassword%  && (
  echo createipsandcerts was successful
) || (
  echo createipsandcerts failed
  EXIT /B 1
)

call installconsul.bat  && (
  echo installconsulwas successful
) || (
  echo installconsul failed
  EXIT /B 1
)

call installvault.bat  && (
  echo installvaultwas successful
) || (
  echo installvault failed
  EXIT /B 1
)

call createsecrets.bat %adminusername% %adminpassword% %mpsapikey% %mpspassword% %rpsapikey% %sessionEncryptionKey% %redisPassword% && (
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