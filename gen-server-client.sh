#!/bin/sh

set -e

# Do 'sudo apt install uuid' if necessary.
uuid=$(uuid -v4)
cn=${1:-$uuid}

# Generate server/client key.
openssl genrsa -aes256 \
	-passout file:secrets/server-client-secret \
	-out intermediate/private/$cn.key.pem 2048
chmod 400 intermediate/private/$cn.key.pem

openssl rsa -in intermediate/private/$cn.key.pem \
	-passin file:secrets/server-client-secret \
	-out intermediate/private/$cn.nopw.key.pem
chmod 400 intermediate/private/$cn.nopw.key.pem

# Generate client/server CSR.
export COMMON_NAME=$cn.peer.example.com
openssl req -config intermediate/openssl.cnf \
	-passin file:secrets/server-client-secret \
	-key intermediate/private/$cn.key.pem \
	-new -sha256 -out intermediate/csr/$cn.csr.pem

# Sign client/server CSR to get certificate.
openssl ca -batch -config intermediate/openssl.cnf \
	-extensions server_client_cert -days 375 -notext -md sha256 \
	-passin file:secrets/intermediate-secret \
	-in intermediate/csr/$cn.csr.pem \
	-out intermediate/certs/$cn.cert.pem
chmod 444 intermediate/certs/$cn.cert.pem

echo "Server/Client certificate generated."
echo "Use the following command to copy the files needed for deployment:"
echo "   cp intermediate/certs/$cn.cert.pem intermediate/certs/ca-chain.cert.pem intermediate/private/$cn.key.pem intermediate/private/$cn.nopw.key.pem DEST"

