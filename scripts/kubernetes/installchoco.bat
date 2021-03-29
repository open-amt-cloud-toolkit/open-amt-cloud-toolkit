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

powershell -command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

echo please open a new command prompt to install choco packages