## Basic documentation

* [Create and Install Client and Server SSL Certificates for PostgreSQL Database](https://luppeng.wordpress.com/2021/08/07/create-and-install-ssl-certificates-for-postgresql-database-running-locally/)
* [Guide to Testing an SSL Connection Using OpenSSL](https://www.liquidweb.com/kb/how-to-test-ssl-connection-using-openssl/)

## Generate certificates

This requires openssl to be installed. Just call:

```bash
gencert.sh
```

This generates:
- CA self signed certificate
- Server certificate for PostgreSQL

Sample certificates are already generated, so no need to call `gencert.sh`.
- ca.*     - CA cert signing request, key and certificate
- server.* - server cert signing request, key and certificate
- client.* - client cert signing request, key and certificate

With `genclient.sh` you can generate clients' certificates. Eg.:

```bash
genclient.sh marek
```

will generate certificate with `CN=marek`. Caution: CN **must** be equal to the database user name.

## Start services

```bash
docker-compose up -d
```

To stop it execute:

```bash
docker-compose stop
```

## Configuration

The default name of the database, user and password for PostgreSQL can be changed in the [`.env`](.env) file in the current directory.

In order to validate all database connections with certificates (mTLS) edit `/var/lib/postgresql/data/pg_hba.conf` and leave only the following line:

```
hostssl all all all cert clientcert=1
```

This line is normally appended to the file above, so other authentication methods defined in this file are also valid.


## Testing

### Testing connection to PostgreSQL server with psql

```bash
psql postgresql://postgres:postgres@ssltest-postgres.docker_default:5432/postgres?sslmode=disable
```

```bash
psql postgresql://postgres:postgres@ssltest-postgres.docker_default:5432/postgres?sslmode=require
```

```bash
psql postgresql://postgres:postgres@ssltest-postgres.docker_default:5432/postgres?sslmode=verify-ca
```

```bash
psql postgresql://postgres:postgres@ssltest-postgres.docker_default:5432/postgres?sslmode=verify-full
```

Other way to call psql:

```
psql "port=5432 host=ssltest-postgres.docker_default user=n8nuser dbname=postgres sslcert=./n8nuser.crt sslkey=./n8nuser.key sslrootcert=./root.crt sslmode=verify-full"
```

user `n8nuser` must be defined in the database and must be equal to the CN in the provided certificate.

### Testing connection and SSL with openssl

```
openssl s_client -connect ssltest-postgres.docker_default:5432
```

This gives only this:

```
CONNECTED(00000003)
write:errno=0
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 0 bytes and written 176 bytes
Verification: OK
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : 0000
    Session-ID:
    Session-ID-ctx:
    Master-Key:
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    Start Time: 1699868630
    Timeout   : 7200 (sec)
    Verify return code: 0 (ok)
    Extended master secret: no
```

And every simple HTTPS web site gives this:

```
openssl s_client -connect hycom.pl:443
```

```
CONNECTED(00000003)
depth=0 C = PL, CN = hycom.at
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 C = PL, CN = hycom.at
verify error:num=21:unable to verify the first certificate
verify return:1
---
Certificate chain
 0 s:/C=PL/CN=hycom.at
   i:/C=CN/O=WoSign CA Limited/CN=WoSign CA Free SSL Certificate G2
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIF3DCCBMSgAwIBAgIQGhOEdf1ndKg0h6lNsh9gUTANBgkqhkiG9w0BAQsFADBV
MQswCQYDVQQGEwJDTjEaMBgGA1UEChMRV29TaWduIENBIExpbWl0ZWQxKjAoBgNV
BAMTIVdvU2lnbiBDQSBGcmVlIFNTTCBDZXJ0aWZpY2F0ZSBHMjAeFw0xNjA4Mjky
MDQ5MTFaFw0xOTA4MjkyMDQ5MTFaMCAxCzAJBgNVBAYTAlBMMREwDwYDVQQDDAho
eWNvbS5hdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMDJiLQxgt83
DIyNAtpuFyGS1WuaE6UGHRP/hnNTEJuPfmycYp3LhgjoZL3txs4PfoatxN6bgJep
h+WM/wVOFZBE/Ta3Vs5szZE8cxeuEMrER2eeKV2FzVuuDfXBQ3/zqxEITRdu6ZXQ
M5ToT+FX3N2zZhOTnQ7kYhC0jvUrtNBggZ6T/bPWH4U2Z/vR8x5qnwMYibrVq0FD
E4iG0AF89NCofGIcTNskCvkHWxfi6CFsQB3yJCZbT4FFT55ScvYriAChcoNwJH3H
oZz+CPvXaAsewsSZzcix8v+uNaZKrzRsJFvf9n7Lm58qgq3RyOal5mzt7Uc7Qhml
Hoke6NfhsYMCAwEAAaOCAtswggLXMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAU
BggrBgEFBQcDAgYIKwYBBQUHAwEwCQYDVR0TBAIwADAdBgNVHQ4EFgQUgs3NtADR
B43IinJwDKCFFVbeAKQwHwYDVR0jBBgwFoAU0qcWIHyv2ZWe60MKGfLguXQOqMcw
fQYIKwYBBQUHAQEEcTBvMDQGCCsGAQUFBzABhihodHRwOi8vb2NzcDEud29zaWdu
LmNvbS9jYTYvc2VydmVyMS9mcmVlMDcGCCsGAQUFBzAChitodHRwOi8vYWlhMS53
b3NpZ24uY29tL2NhNi5zZXJ2ZXIxLmZyZWUuY2VyMD0GA1UdHwQ2MDQwMqAwoC6G
LGh0dHA6Ly9jcmxzMS53b3NpZ24uY29tL2NhNi1zZXJ2ZXIxLWZyZWUuY3JsMEQG
A1UdEQQ9MDuCCGh5Y29tLmF0ggx3d3cuaHljb20uYXSCCGh5Y29tLmNogghoeWNv
bS5pdIINaHljb20uZGlnaXRhbDBPBgNVHSAESDBGMAgGBmeBDAECATA6BgsrBgEE
AYKbUQEBAjArMCkGCCsGAQUFBwIBFh1odHRwOi8vd3d3Lndvc2lnbi5jb20vcG9s
aWN5LzCCAQQGCisGAQQB1nkCBAIEgfUEgfIA8AB1AGj2mPgfZIK+OozuuSgdTPxx
UV1nk9RE0QpnrLtPT/vEAAABVtgr7w0AAAQDAEYwRAIgKICZgA/rjLBx1AjKUo/v
USeH360ch6CGA4GNdILnlS0CIDfbTc6rqCzfNFsENdHyrFWSS/7/+C6giVjFQ5vN
gJGmAHcApLkJkLQYWBSHuxOizGdwCjw1mAT5G9+443fNDsgN3BAAAAFW2CvwLgAA
BAMASDBGAiEAsBuys9H6ou8qlmqczguiqHGuH3e7cBzWA6xCo8818yQCIQDwJ3O5
VZ1Q7giOE/hkaVUFl0btWywJ6Cj0PzfIto9s9DANBgkqhkiG9w0BAQsFAAOCAQEA
2zj4R+vz3J9RDwJT++8hYGxI3xeA3DEC56UkHQ0R8bXEuKsXjGYfkYgYD+j6Vhtg
mhFGstXu1wOUbA1a32gQRLgQif6NhcT+ggfvxRt4sig5IZTSwjdgdqM7OO6/wDcm
/7aAo8M5eQKfAP6Yf55vi8tfk8G6iqmKemA/2qdofwmabnxQlrOJUf4oCxJoLDHE
JD629tVV4oozw1gqdHhn1te3g78vdEx7Q4icZw5uE2g6fn9o1ziyjzjACCAqdpOG
Py/PgpCmMYli/NjvCXlWRjvn5DqA4H+rgKlarLwiwWAUFkm1AyCjTXxrYyptih80
DpAmQha5NOFJGOPkZLFeLw==
-----END CERTIFICATE-----
subject=/C=PL/CN=hycom.at
issuer=/C=CN/O=WoSign CA Limited/CN=WoSign CA Free SSL Certificate G2
---
No client certificate CA names sent
Peer signing digest: SHA512
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 2011 bytes and written 302 bytes
Verification error: unable to verify the first certificate
---
New, TLSv1.2, Cipher is ECDHE-RSA-AES128-GCM-SHA256
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES128-GCM-SHA256
    Session-ID: 673057269F6926AD014D09F4ECBBB73369896553B4471B16601DA989107548DF
    Session-ID-ctx:
    Master-Key: B43B48CE6DA8000B233F4C4DCC38DB01739AC4F078E0E6AA3083171E9960F8963AF364D4FCED17AB232B1E6C76AD80DF
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    Start Time: 1699868919
    Timeout   : 7200 (sec)
    Verify return code: 21 (unable to verify the first certificate)
    Extended master secret: no
---
DONE
```

Now, the problem with PostgreSQL is:

Q: "why does openssl s_client fail to retrieve the cert"?

A: The cert is received as part of the TLS handshake, but "handshake fail[ed]" so it wasn't received. Although Postgres uses TLS, it does NOT do so immediately on connection, as your command is attempting; instead it does a postgres-specific protocol first and THEN starts TLS. Many other protocols also do this.
