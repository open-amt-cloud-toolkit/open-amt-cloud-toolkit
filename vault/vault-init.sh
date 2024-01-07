#!/bin/sh
set -eu
umask 077
export VAULT_ADDR="http://127.0.0.1:8200"
sleep 3
cd /vault/file
if [ ! -d .vault-init ]; then
    install -d -m 700 .vault-init
fi
cd .vault-init
if [ ! -f init.log ]; then
    vault operator init >init.log
fi
if [ ! -f root-token.txt ]; then
    awk '/Unseal Key [0-9]+: /{print $4}' init.log | head -3 >unseal-keys.txt
    awk '/Initial Root Token: /{print $4}' init.log | tr -d '\n' >root-token.txt
fi
for key in $(cat unseal-keys.txt); do
    vault operator unseal "$key"
done
export VAULT_TOKEN="$(cat root-token.txt)"
if [ -z "$(vault audit list | grep ^file/)" ]; then
    vault audit enable file file_path=stdout log_raw=true
fi
if [ -z "$(vault auth list | grep ^userpass/)" ]; then
    vault auth enable userpass
fi
if [ -z "$(vault secrets list | grep ^secret/)" ]; then
    vault secrets enable -version=2 -path=secret kv
fi
vault policy write oact - <<EOF
path "secret/data/*" {
    capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
path "secret/data/*" {
    capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
EOF
vault write auth/userpass/users/rps \
    policies=oact,default \
    password=rps
vault write auth/userpass/users/mps \
    policies=oact,default \
    password=mps
