#!/bin/sh

set -e

# Generate Intermediate CA key.
openssl genrsa -aes256 \
	-passout file:secrets/intermediate-secret \
	-out intermediate/private/intermediate.key.pem 4096
chmod 400 intermediate/private/intermediate.key.pem

# Generate Intermediate CA CSR.
export COMMON_NAME="Intermediate CA"
openssl req -config intermediate/openssl.cnf -new -sha256 \
	-passin file:secrets/intermediate-secret \
	-key intermediate/private/intermediate.key.pem \
	-out intermediate/csr/intermediate.csr.pem

# Sign CSR to get certificate
openssl ca -batch -config openssl.cnf -extensions v3_intermediate_ca \
	-passin file:secrets/ca-secret \
	-days 3650 -notext -md sha256 \
	-in intermediate/csr/intermediate.csr.pem \
	-out intermediate/certs/intermediate.cert.pem
chmod 444 intermediate/certs/intermediate.cert.pem

# Generate CA chain for deployment with server/client certificates.
cat intermediate/certs/intermediate.cert.pem \
    certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
chmod 444 intermediate/certs/ca-chain.cert.pem
