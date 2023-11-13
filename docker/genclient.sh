#!/bin/sh

if [ -z "$1" ]
then
    echo "usage: genclient <CN of a client>, where CN must equal database user name, eg. n8nuser, or postgres, or testuser1, etc."
    exit 1
fi

CN=$1

# CSR
openssl req -new -nodes -text -out ${CN}.csr -keyout ${CN}.key -subj "/CN=${CN}"
chmod og-rwx ${CN}.key

# Sign the server request with CA crt and key and generate server certificate
openssl x509 -req -in ${CN}.csr -text -days 365 -CA ca.crt -CAkey ca.key -CAcreateserial -out ${CN}.crt
