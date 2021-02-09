:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

if "" == "%~1" (
echo usage: cleanup.bat [vault-helm-stack-name] [openamt-helm-stack-name]
EXIT /B 1
)

if "" == "%~2" (
echo usage: cleanup.bat [vault-helm-stack-name] [openamt-helm-stack-name]
EXIT /B 1
)

rmdir vault /s /q

set vault=%1
set openamtstack=%2

helm uninstall %vault% && (
  echo vault uninstall successful
) || (
  echo vault uninstall failed
)
kubectl delete persistentvolumeclaim data-vault-0 && (
  echo data-vault-0 removal successful
) || (
  echo data-vault-0 removal failed
)
helm uninstall %openamtstack% && (
  echo openamtstack uninstall successful
) || (
  echo openamtstack uninstall failed
)
kubectl delete secret mpsweb && (
  echo mpsweb secret deleted successfully
) || (
  echo mpsweb secret deletion failed
)
kubectl delete secret mpsapi && (
  echo mpsapi secret deleted successfully
) || (
  echo mpsapi secret deletion failed
)
kubectl delete secret mpscreds && (
  echo mpscreds secret deleted successfully
) || (
  echo mpscreds secret deletion failed
)
kubectl delete secret rpsapi && (
  echo rpsapi secret deleted successfully
) || (
  echo rpsapi secret deletion failed
)
kubectl delete secret regcred && (
  echo regcred secret deleted successfully
) || (
  echo regcred secret deletion failed
)
kubectl delete secret mpscerts && (
  echo mpscerts secret deleted successfully
) || (
  echo mpscerts secret deletion failed
)
kubectl delete secret rpscerts && (
  echo rpscerts secret deleted successfully
) || (
  echo rpscerts secret deletion failed
)
kubectl delete secret vaultaccess && (
  echo vaultaccess secret deleted successfully
) || (
  echo vaultaccess secret deletion failed
)