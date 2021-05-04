:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

@echo off 

if "" == "%~1" (
echo usage: createipandcerts.bat [myResourceGroup] [myAKSCluster] [pfxPassword]
EXIT /B 1
)

if "" == "%~2" (
echo usage: createipandcerts.bat [myResourceGroup] [myAKSCluster] [pfxPassword]
EXIT /B 1
)

if "" == "%~3" (
echo usage: createipandcerts.bat [myResourceGroup] [myAKSCluster] [pfxPassword]
EXIT /B 1
)

set myResourceGroup=%1
set myAKSCluster=%2
set pfxPassword=%3

call az aks show --resource-group %myResourceGroup% --name %myAKSCluster% --query nodeResourceGroup -o tsv > temp  && (
 echo nodeResourceGroup query successfully
) || (
  echo nodeResourceGroup query failed
  EXIT /B 1
)

set /p nodeResourceGroup=<temp

call az network public-ip create --resource-group %nodeResourceGroup% --name mpsip --sku Standard --allocation-method static  && (
 echo allocating mpsip static ip successful
) || (
  echo allocating mpsip static ip failed
  EXIT /B 1
)


call az network public-ip create --resource-group %nodeResourceGroup% --name uiip --sku Standard --allocation-method static  && (
 echo allocating uiip static ip successfully
) || (
  echo allocating uiip static ip failed
  EXIT /B 1
)


call az network public-ip show --resource-group %nodeResourceGroup% --name mpsip --query ipAddress --output tsv > temp1  && (
 echo mpsip ipaddress query successfully
) || (
  echo mpsip ipaddress query failed
  EXIT /B 1
)

set /p mps_ip_address=<temp1


call az network public-ip show --resource-group %nodeResourceGroup% --name uiip --query ipAddress --output tsv > temp2  && (
 echo uiip ipaddress query successfully
) || (
  echo uiip ipaddress query  failed
  EXIT /B 1
)

set /p ui_ip_address=<temp2

echo "MPS IP ADDRESS" %mps_ip_address%
echo "UI IP ADDRESS" %ui_ip_address%
echo "Node Resource Group" %nodeResourceGroup%


@echo STATIC_IP_MPS=%mps_ip_address% >> .env
@echo STATIC_IP_UI=%ui_ip_address% >> .env
@echo NODE_RESOURCE_GROUP=%nodeResourceGroup% >> .env

del temp
del temp1 
del temp2

gencerts.bat %ui_ip_address% %mps_ip_address% %pfxPassword%