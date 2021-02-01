:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

echo off

helm repo add hashicorp https://helm.releases.hashicorp.com && (
  echo helm repo added successful
) || (
  echo helm repo add failed
  EXIT /B 1
)

helm install consul hashicorp/consul --set global.name=consul && (
  echo consul install successful
) || (
  echo consul install failed
  EXIT /B 1
)
