# ca-skeleton
Skeleton setup for OpenSSL CA.

'''Never use these scripts in production. The passwords used to protect the secret keys are static and public.'''

The code in this repo can be used when you need to set up a private CA
for testing or learning purposes.  The included tools let you create a
root CA, by generating a CA private key and the files OpenSSL requires
to sign certificates.  Also, you can create an intermediate CA signed
by the root CA, which in turn can be used to sign end-user certificates.

The following tools are included:

- gen-ca.sh: generates a private key and necessary files to sign certificates
- gen-intermediate.sh: uses the key and files created above to create an intermediate CA (again, including key, certificate chain and support files)
- gen-server-client.sh: generates end-user certificates with certificate extensions that allow use as server and client certificates.

The configuration files and commands are based on Jamie Nguyen's
wonderful tutorial on creating an OpenSSL CA at
https://jamielinux.com/docs/openssl-certificate-authority/sign-server-and-client-certificates.html
