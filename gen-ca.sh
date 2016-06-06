#!/bin/sh

set -e

# Generate Root CA key
openssl genrsa -aes256 \
	-passout file:secrets/ca-secret \
	-out private/ca.key.pem 4096
chmod 400 private/ca.key.pem

# Generate Root CA certificate
export COMMON_NAME="Root CA"
openssl req -config openssl.cnf \
      -key private/ca.key.pem \
      -passin file:secrets/ca-secret \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out certs/ca.cert.pem
