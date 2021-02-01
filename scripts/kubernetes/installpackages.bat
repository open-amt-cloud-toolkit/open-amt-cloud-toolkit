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