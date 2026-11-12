# syntax=docker/dockerfile:1
FROM mysql:8.4 AS mysql

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --start-interval=2s --retries=3 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD
