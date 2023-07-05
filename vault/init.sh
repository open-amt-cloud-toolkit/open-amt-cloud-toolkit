server="http://vault:8200"
system_url="${server}/v1/sys"
secrets_file="secrets.json"

is_initialized=$(curl -s ${system_url}/init | jq '.initialized')
if [ "${is_initialized}" == "false" ]; then
  echo "initializing vault"
  curl -s \
    --data '{"secret_shares":2, "secret_threshold":2}' \
   ${system_url}/init \
   jq '.' > ${secrets_file}
else
  echo "vault is initialized"
fi

 
is_sealed=$(curl -s ${system_url}/seal-status | jq '.sealed')
readarray -t unseal_keys < <(jq --compact-output '.keys[]' ${secrets_file})
# iterate through the Bash array
for key in "${unseal_keys[@]}"; do
  if [ "${is_sealed}" == "true" ]; then
    echo "unsealing vault with key ${key}"
    is_sealed=$(curl -s \
      ${system_url}/unseal \
      --data '{"key":'${key}'}' \
      | jq '.sealed')
  else
    echo "vault is unsealed"
    break
  fi
done

export VAULT_TOKEN=$(jq -r ".root_token" ${secrets_file})
echo "VAULT_TOKEN=${VAULT_TOKEN}"

is_kv_engine_enabled=$(curl -s \
  --header "X-Vault-Token: $VAULT_TOKEN" \
  ${system_url}/mounts \
  | jq 'has("kv/")')
if [ "${is_kv_engine_enabled}" == "false" ]; then
  echo "enabling kv secrets engine version 2"
  curl -s \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --data '{ "type": "kv-v2" }' \
    ${system_url}/mounts/kv
else
  echo "vault kv version2 engine is enabled"
fi
