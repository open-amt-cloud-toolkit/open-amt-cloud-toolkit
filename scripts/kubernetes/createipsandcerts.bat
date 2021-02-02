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

call az network public-ip create --resource-group %nodeResourceGroup% --name mpswebip --sku Standard --allocation-method static  && (
 echo allocating mpswebip static ip successful
) || (
  echo allocating mpswebip static ip failed
  EXIT /B 1
)

call az network public-ip create --resource-group %nodeResourceGroup% --name rpsip --sku Standard --allocation-method static  && (
 echo allocating rpsip static ip successfully
) || (
  echo allocating rpsip static ip failed
  EXIT /B 1
)

call az network public-ip create --resource-group %nodeResourceGroup% --name uiip --sku Standard --allocation-method static  && (
 echo allocating uiip static ip successfully
) || (
  echo allocating uiip static ip failed
  EXIT /B 1
)


call az network public-ip show --resource-group %nodeResourceGroup% --name mpsip --query ipAddress --output tsv > temp2  && (
 echo mpsip ipaddress query successfully
) || (
  echo mpsip ipaddress query failed
  EXIT /B 1
)

set /p mps_ip_address=<temp2


call az network public-ip show --resource-group %nodeResourceGroup% --name mpswebip --query ipAddress --output tsv > temp3  && (
 echo mpswebip ipaddress query successfully
) || (
  echo mpswebip ipaddress query failed
  EXIT /B 1
)

set /p mpsweb_ip_address=<temp3



call az network public-ip show --resource-group %nodeResourceGroup% --name rpsip --query ipAddress --output tsv > temp4  && (
 echo rpsip ipaddress query successfully
) || (
  echo rpsip ipaddress query  failed
  EXIT /B 1
)

set /p rps_ip_address=<temp4

call az network public-ip show --resource-group %nodeResourceGroup% --name uiip --query ipAddress --output tsv > temp5  && (
 echo uiip ipaddress query successfully
) || (
  echo uiip ipaddress query  failed
  EXIT /B 1
)

set /p ui_ip_address=<temp5

echo "MPS IP ADDRESS" %mps_ip_address%
echo "MPS WEB IP ADDRESS" %mpsweb_ip_address%
echo "RPS IP ADDRESS" %rps_ip_address%
echo "UI IP ADDRESS" %ui_ip_address%
echo "Node Resource Group" %nodeResourceGroup%


@echo STATIC_IP_MPS=%mps_ip_address% >> .env
@echo STATIC_IP_WEB=%mpsweb_ip_address% >> .env
@echo STATIC_IP_RPS=%rps_ip_address% >> .env
@echo STATIC_IP_UI=%ui_ip_address% >> .env
@echo NODE_RESOURCE_GROUP=%nodeResourceGroup% >> .env

del temp 
del temp2
del temp3
del temp4
del temp5

gencerts.bat %mps_ip_address% %rps_ip_address% %pfxPassword% %mpsweb_ip_address%