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

Other wayy to call psql:

```
psql "port=5432 host=ssltest-postgres.docker_default user=n8nuser dbname=postgres sslcert=./n8nuser.crt sslkey=./n8nuser.key sslrootcert=./root.crt sslmode=verify-full"
```

user `n8nuser` must be defined in the database and must be equal to the CN in the provided certificate.
