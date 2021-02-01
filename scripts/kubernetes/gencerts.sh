#/*********************************************************************
# Copyright (c) Intel Corporation 2020
# SPDX-License-Identifier: Apache-2.0
#**********************************************************************/

rootCAForMps=rootCA_mps
rootCAForRps=rootCA_rps
serverCertMps=mps_cert
serverCertRps=rps_cert

rootCAKey_mps="$rootCAForMps.key"
rootCACert_mps="$rootCAForMps.crt"
rootCAKey_rps="$rootCAForRps.key"
rootCACert_rps="$rootCAForRps.crt"


serverKey_mps="$serverCertMps.key"
serverCert_mps="$serverCertMps.crt"
serverKey_rps="$serverCertRps.key"
serverCert_rps="$serverCertRps.crt"

CN_MPS=$1
CN_RPS=$2

PFXPASSWORD=$3

subj_ROOT="/C=US/ST=AZ/O=demo,Inc./CN=MPSRoot-"
subj_MPS="/C=US/CN=$CN_MPS"
subj_RPS="/C=US/ST=AZ/O=demo,Inc./CN=$CN_RPS"

#echo $subj_MPS $subj_RPS


generate(){
  rootCAKey=$1
  rootCACert=$2
  serverKey=$3
  serverCert=$4
  subj=$5
  rootsubj=$6

  # Generate root ca key
  #openssl genrsa -des3 -passout pass:$PFXPASSWORD -out $rootCAKey 3072
  openssl genrsa -out $rootCAKey 3072

  openssl rsa -in $rootCAKey -pubout | openssl asn1parse -strparse 19 -out "$rootCAKey.pub"

  hash=$(openssl dgst -sha1 $rootCAKey.pub | cut -c 27-)
  thumb="${hash:0:6}"

  serial="$((1 + RANDOM % 1000000))"
  # Generate root crt..this is distributed to other devices
  # echo "  openssl req -x509 -new -nodes -key $rootCAKey -set_serial $serial -sha384 -days 1024 -subj "$rootsubj$thumb" -config ./openssl.cnf -extensions v3_ca -out $rootCACert "
  openssl req -x509 -new -nodes -key $rootCAKey -set_serial $serial -sha384 -days 1024 -subj "$rootsubj$thumb" -config ./openssl.cnf -extensions v3_ca -out $rootCACert 

  serverserial="$((1 + RANDOM % 1000000))"
  # Generate key for a device
  openssl genrsa -out $serverKey 2048

  # Generate CSR for the key. Make sure you update the IP address (this is the static IP address for this server) in CN
  openssl req -new -sha256 -key $serverKey -subj "$subj" -out "$serverCert.csr"

  # Generate cert that signed by root CA
  openssl x509 -req -in "$serverCert.csr" -CA $rootCACert -set_serial $serverserial -CAkey $rootCAKey -passin pass:$PFXPASSWORD -CAcreateserial -extfile ./openssl.cnf \
      -extensions server_cert -out $serverCert -days 5000 -sha384
}

createSecret(){
  echo "kubectl create secret generic $1 --from-file=$2 --from-file=$3 --from-file=$4 --from-file=$5"
  kubectl create secret generic $1 --from-file=$2 --from-file=$3 --from-file=$4 --from-file=$5 
}

generate $rootCAKey_mps $rootCACert_mps $serverKey_mps $serverCert_mps $subj_MPS $subj_ROOT
generate $rootCAKey_rps $rootCACert_rps $serverKey_rps $serverCert_rps $subj_RPS $subj_ROOT

echo "Creating kubectl secrets with name \"mpscerts\" and keys $rootCAKey_mps $rootCACert_mps $serverKey_mps $serverCert_mps "
createSecret mpscerts $rootCAKey_mps $rootCACert_mps $serverKey_mps $serverCert_mps

echo "Creating kubectl secrets with name \"rpscerts\" and keys $rootCAKey_rps $rootCACert_rps $serverKey_rps $serverCert_rps "
createSecret rpscerts $rootCAKey_rps $rootCACert_rps $serverKey_rps $serverCert_rps