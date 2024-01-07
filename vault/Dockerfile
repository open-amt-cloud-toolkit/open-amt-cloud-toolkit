# see https://hub.docker.com/r/hashicorp/vault
# see https://github.com/hashicorp/vault/blob/v1.15.4/Dockerfile
# see https://github.com/hashicorp/vault/blob/v1.15.4/.release/docker/docker-entrypoint.sh
FROM hashicorp/vault:1.15.4
COPY *.sh /usr/local/bin/
ENTRYPOINT ["vault-init-docker-entrypoint.sh"]
CMD ["server"]
