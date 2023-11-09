FROM ubuntu:22.04

RUN apt update && apt install -y iputils-ping postgresql-client openssl && mkdir -p /root/.postgresql

COPY ../ca.crt /root/.postgresql/root.crt

ENTRYPOINT ["tail", "-f", "/dev/null"]
