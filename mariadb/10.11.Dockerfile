# syntax=docker/dockerfile:1
# Version of Ubuntu 24.04
FROM mariadb:11.5 AS mariadb

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD
