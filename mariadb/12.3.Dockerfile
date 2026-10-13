# syntax=docker/dockerfile:1
FROM mariadb:12.3 AS mariadb

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD ["healthcheck.sh", "--connect", "--innodb_initialized"]
