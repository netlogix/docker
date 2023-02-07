# syntax=docker/dockerfile:1
FROM mariadb:10.10.3 as mariadb

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD


FROM mariadb:10.10.3 as mariadb_106

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD


FROM mariadb:10.10.3 as mariadb_103

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD
