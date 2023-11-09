## Generate certificates

This requires openssl to be installed. Just call:

```bash
gencert.sh
```

This generates:
- CA self signed certificate
- Server certificate for PostgreSQL
- sample client certificate


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
