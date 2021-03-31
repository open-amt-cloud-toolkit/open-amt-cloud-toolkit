:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO admin rights found! 
) ELSE (
    ECHO must be ran as an admin!
    EXIT /B 1
)

choco install azure-cli -y  && (
  echo azure-cli install successful
) || (
  echo azure-cli install failed
  EXIT /B 1
)

choco install git -y && (
  echo git install successful
) || (
  echo git install failed
  EXIT /B 1
)

choco install nodejs -y && (
  echo nodejs install successful
) || (
  echo nodejs install failed
  EXIT /B 1
)

choco install openssl -y && (
  echo openssl install successful
) || (
  echo openssl install failed
  EXIT /B 1
)

choco install kubernetes-helm -y && (
  echo install successful
) || (
  echo install failed
  EXIT /B 1
)

choco install kubernetes-cli -y && (
  echo kubernetes-cli install successful
) || (
  echo kubernetes-cli install failed
  EXIT /B 1
)

choco install postman -y && (
  echo postman install successful
) || (
  echo postman install failed
  EXIT /B 1
)

choco install curl -y && (
  echo curl install successful
) || (
  echo curl install failed
  EXIT /B 1
)