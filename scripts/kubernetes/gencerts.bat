:: /*********************************************************************
:: Copyright (c) Intel Corporation 2020
:: SPDX-License-Identifier: Apache-2.0
:: **********************************************************************/

@echo off

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO admin rights found! 
) ELSE (
    ECHO must be ran as an admin!
    EXIT /B 1
)

set rootCAForMps=rootCA_mps
set rootCAForMpsweb=rootCA_mpsweb
set rootCAForRps=rootCA_rps
set serverCertMps=mps_cert
set serverCertMpsweb=mpsweb_cert
set serverCertRps=rps_cert


set rootCAKey_mps="%rootCAForMps%.key"
set rootCACert_mps="%rootCAForMps%.crt"
set rootCAKey_mpsweb="%rootCAForMpsweb%.key"
set rootCACert_mpsweb="%rootCAForMpsweb%.crt"
set rootCAKey_rps="%rootCAForRps%.key"
set rootCACert_rps="%rootCAForRps%.crt"


set serverKey_mps="%serverCertMps%.key"
set serverCert_mps="%serverCertMps%.crt"
set serverKey_mpsweb="%serverCertMpsweb%.key"
set serverCert_mpsweb="%serverCertMpsweb%.crt"
set serverKey_rps="%serverCertRps%.key"
set serverCert_rps="%serverCertRps%.crt"

set CN_MPS=%1
set CN_RPS=%2
set PFXPASSWPRD=%3
set CN_MPSWEB=%4
set subj_ROOT="/C=US/ST=AZ/O=demo,Inc./CN=MPSRoot"
set subj_MPS="/C=US/CN=%CN_MPS%"
set subj_MPSWEB="/C=US/CN=%CN_MPSWEB%"
set subj_RPS="/C=US/ST=AZ/O=demo,Inc./CN=%CN_RPS%"



SETLOCAL
PowerShell -Command "& {Set-Date -Date (Get-Date).AddDays(-1)}"  | find "FullyQualifiedErrorId"
if not ERRORLEVEL 1 (
echo Error setting date backward
exit /b 1
)

echo setting time backward passed


call :Generate %rootCAKey_mps% %rootCACert_mps% %serverKey_mps% %serverCert_mps% %subj_MPS% %subj_ROOT%
call :Generate %rootCAKey_mpsweb% %rootCACert_mpsweb% %serverKey_mpsweb% %serverCert_mpsweb% %subj_MPSWEB% %subj_ROOT%
call :Generate %rootCAKey_rps% %rootCACert_rps% %serverKey_rps% %serverCert_rps% %subj_RPS% %subj_ROOT%

PowerShell -Command "& {Set-Date -Date (Get-Date).AddDays(1)}"| find "FullyQualifiedErrorId"
if not ERRORLEVEL 1 (
echo Error setting date forward
exit /b 1
)

echo setting time forward passed


echo "Creating kubectl secrets with name \"mpscerts\" and keys %rootCAKey_mps% %rootCACert_mps% %serverKey_mps% %serverCert_mps% "
call :createSecret mpscerts %rootCAKey_mps% %rootCACert_mps% %serverKey_mps% %serverCert_mps%

echo "Creating kubectl secrets with name \"mpscerts\" and keys %rootCAKey_mpsweb% %rootCACert_mpsweb% %serverKey_mpsweb% %serverCert_mpsweb% "
call :createSecret mpswebcerts %rootCAKey_mpsweb% %rootCACert_mpsweb% %serverKey_mpsweb% %serverCert_mpsweb% 

echo "Creating kubectl secrets with name \"rpscerts\" and keys %rootCAKey_rps% %rootCACert_rps% %serverKey_rps% %serverCert_rps% "
call :createSecret rpscerts %rootCAKey_rps% %rootCACert_rps% %serverKey_rps% %serverCert_rps%

EXIT /B %ERRORLEVEL%


:Generate
set rootCAKey=%~1
set rootCACert=%~2
set serverKey=%~3
set serverCert=%~4
set subj=%~5
set rootsubject=%~6


Rem Generate root ca key
rem openssl genrsa -des3 -passout pass:%PFXPASSWORD% -out %rootCAKey% 3072
openssl genrsa -out %rootCAKey% 3072


Rem Generate root crt..this is distributed to other devices
echo "openssl req -x509 -new -nodes -key %rootCAKey% -sha256 -days 1024 -subj "%subj%" -out %rootCACert%"
rem openssl req -x509 -new -nodes -key %rootCAKey% -passin pass:%PFXPASSWORD% -sha256 -days 1024 -subj "%subj%" -out %rootCACert%

openssl req -x509 -new -nodes -key %rootCAKey% -sha384 -days 1024 -subj "%rootsubject%" -config ./openssl.cnf -extensions v3_ca -out %rootCACert% 


Rem Generate key for a device
openssl genrsa -out %serverKey% 2048

Rem Generate CSR for the key. Make sure you update the IP address (this is the static IP address for this server) in CN
openssl req -new -sha256 -key %serverKey% -subj "%subj%" -out %serverCert%.csr

Rem Generate cert that signed by root CA
rem openssl x509 -req -in "%serverCert%.csr" -CA %rootCACert% -CAkey %rootCAKey% -passin pass:%PFXPASSWORD% -CAcreateserial -out %serverCert% -days 500 -sha256
openssl x509 -req -in "%serverCert%.csr" -CA %rootCACert%  -CAkey %rootCAKey% -passin pass:%PFXPASSWORD% -CAcreateserial -extfile ./openssl.cnf -extensions server_cert -out %serverCert% -days 5000 -sha384

EXIT /B 0

:createSecret
call kubectl create secret generic %~1 --from-file=%~2 --from-file=%~3 --from-file=%~4 --from-file=%~5 && (
    echo creating secret %~1 was successful
    EXIT /B 0

) || ( 
  echo creating secret %~1 failed
    EXIT /B 1
)

:End