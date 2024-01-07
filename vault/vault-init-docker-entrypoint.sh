#!/usr/bin/dumb-init /bin/sh
set -eu
vault-init.sh &
exec docker-entrypoint.sh "$@"
