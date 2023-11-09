## Generate certificates

This requires openssl to be installed. Just call:

```bash
gencert.sh
```

This generates:
- CA self signed certificate
- Server certificate for PostgreSQL
- sample client certificate

Sample certificates are already generated:
- ca.*     - CA cert signing request, key and certificate
- server.* - server cert signing request, key and certificate
- client.* - client cert signing request, key and certificate


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


## Testing

```bash
psql postgresql://postgres@localhost:5432/postgres?sslmode=disable
```

```bash
psql postgresql://postgres@localhost:5432/postgres?sslmode=require
```

```bash
psql postgresql://postgres@localhost:5432/postgres?sslmode=verify-ca
```

```bash
psql postgresql://postgres@localhost:5432/postgres?sslmode=verify-full
```
