:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

set vaultname=vault-0

helm repo add hashicorp https://helm.releases.hashicorp.com && (
  echo helm install successful
) || (
  echo helm install failed
  EXIT /B 1
)

helm install vault hashicorp/vault && (
  echo helm install successful
) || (
  echo helm install failed
  EXIT /B 1
)


:loopgetpods
kubectl get pod %vaultname% | find "Running"
if ERRORLEVEL 1 (
     echo waiting for running state
    timeout 5
    goto loopgetpods   
)

echo vault ready


kubectl exec -it %vaultname% -- vault operator init -n 1 -t 1 > vault-output.txt 2> vault-output-error.txt
IF %ERRORLEVEL% NEQ 0 (echo vault init failed) else (echo vault init passed)
IF %ERRORLEVEL% NEQ 0 (EXIT /B 1)

powershell -command "(get-content vault-output.txt) -replace '\x1B\x5B0m', '' | set-content vault-output.txt"

type vault-output.txt
type vault-output-error.txt

set _type_cmd=type vault-output.txt

FOR /f "tokens=2 delims=:" %%G IN ('%_type_cmd% ^|find "Unseal Key 1: "') DO set UnsealKey=%%G
FOR /f "tokens=2 delims=:" %%G IN ('%_type_cmd% ^|find "Initial Root Token: "') DO set Token=%%G
for /f "tokens=* delims= " %%a in ("%UnsealKey%") do set UnsealKey=%%a
for /f "tokens=* delims= " %%a in ("%Token%") do set Token=%%a


kubectl exec -it %vaultname% -- vault operator unseal "%UnsealKey%"  && (
  echo vault unseal successful
) || (
  echo vault unseal failed
  EXIT /B 1
)

kubectl exec -it %vaultname% -- vault login %Token%  && (
  echo vault login successful
) || (
  echo vault login failed
  EXIT /B 1
)


kubectl exec -it %vaultname% -- vault secrets enable -version=2 kv  && (
  echo enable kv successful
) || (
  echo enable kv failed
  EXIT /B 1
)

kubectl create secret generic vaultaccess --from-literal=vault-token.txt=%Token%  && (
  echo vault secret token set passed
) || (
  echo vault secret token set failed
  EXIT /B 1
)

kubectl get pod %vaultname% --template={{.status.podIP}} > vaultip.txt && (
  echo exporting pod ip passed
) || (
  echo  exporting pod ip failed
)

set /p vaultip=<vaultip.txt
del vaultip.txt

echo unseal key: %UnsealKey%
echo token: %Token%

@echo VAULT_ADDR=vault >> .env
@echo VAULT_TOKEN=%Token% >> .env
@echo VAULT_UNSEAL_KEY=%UnsealKey% >> .env