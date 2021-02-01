#/*********************************************************************
# Copyright (c) Intel Corporation 2020
# SPDX-License-Identifier: Apache-2.0
#**********************************************************************/
vault=$1
openamtstack=$2

helm uninstall $vault 
kubectl delete persistentvolumeclaim data-vault-0
helm uninstall $openamtstack
kubectl delete secret mpsweb 
kubectl delete secret mpsapi 
kubectl delete secret mpscreds 
kubectl delete secret rpsapi 
kubectl delete secret regcred 
kubectl delete secret mpscerts 
kubectl delete secret rpscerts 
kubectl delete secret vaultaccess 