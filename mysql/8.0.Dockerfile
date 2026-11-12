# syntax=docker/dockerfile:1
FROM mysql:8.0 AS mysql

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=30s --timeout=20s --start-period=60s --start-interval=2s --retries=3 CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD
