#!/bin/sh

set -e

uuid=$(uuidgen)

# Generate server/client key.
openssl genrsa -aes256 \
	-passout file:secrets/server-client-secret \
	-out intermediate/private/$uuid.key.pem 2048
chmod 400 intermediate/private/$uuid.key.pem

# Generate client/server CSR.
export COMMON_NAME=$uuid
openssl req -config intermediate/openssl.cnf \
	-passin file:secrets/server-client-secret \
	-key intermediate/private/$uuid.key.pem \
	-new -sha256 -out intermediate/csr/$uuid.csr.pem

# Sign client/server CSR to get certificate.
openssl ca -batch -config intermediate/openssl.cnf \
	-extensions server_client_cert -days 375 -notext -md sha256 \
	-passin file:secrets/intermediate-secret \
	-in intermediate/csr/$uuid.csr.pem \
	-out intermediate/certs/$uuid.cert.pem
chmod 444 intermediate/certs/$uuid.cert.pem

echo "Server/Client certificate generated."
echo "Use the following command to copy the files needed for deployment:"
echo "   cp intermediate/certs/$uuid.cert.pem intermediate/certs/ca-chain.cert.pem intermediate/private/$uuid.key.pem DEST"

