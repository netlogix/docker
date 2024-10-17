# syntax=docker/dockerfile:1
FROM mysql:9.1 AS mysql

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD
