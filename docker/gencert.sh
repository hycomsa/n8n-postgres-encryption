#!/bin/sh


### Root CA

# CSR
openssl req -new -nodes -text -out ca.csr -keyout ca.key -subj "/CN=ca"
chmod og-rwx ca.key

# Sign the request with the key to create a ca authority certificate (CA certificate)
openssl x509 -req -in ca.csr -text -days 3650 -extfile /etc/ssl/openssl.cnf -signkey ca.key -out ca.crt

### Server CRT

# CSR
openssl req -new -nodes -text -out server.csr -keyout server.key -subj "/CN=ssltest-postgres.docker_default"
chmod og-rwx server.key

# Sign the server request with CA crt and key and generate server certificate
openssl x509 -req -in server.csr -text -days 365 -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
