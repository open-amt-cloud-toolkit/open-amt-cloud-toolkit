# one of: trace, debug, info, warning, error.
log_level = "debug"

ui = true

disable_clustering = true

storage "file" {
    path = "/vault/file"
}

listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = true
}

api_addr = "http://127.0.0.1:8200"
