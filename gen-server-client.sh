#!/bin/sh

uuid=$(uuidgen)

# Generate server/client key.
openssl genrsa -aes256 \
	-out intermediate/private/$uuid.key.pem 2048
chmod 400 intermediate/private/$uuid.key.pem

# Generate CSR
export COMMON_NAME=$uuid
openssl req -config intermediate/openssl.cnf \
      -key intermediate/private/$uuid.key.pem \
      -new -sha256 -out intermediate/csr/$uuid.csr.pem

# Sign CSR to get certificate
openssl ca -batch -config intermediate/openssl.cnf \
      -extensions server_client_cert -days 375 -notext -md sha256 \
      -in intermediate/csr/$uuid.csr.pem \
      -out intermediate/certs/$uuid.cert.pem
chmod 444 intermediate/certs/$uuid.cert.pem
