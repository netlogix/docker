# syntax=docker/dockerfile:1
FROM mariadb:12.3 AS mariadb

COPY config /etc/mysql/conf.d
HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --start-interval=2s --retries=3 CMD ["healthcheck.sh", "--connect", "--innodb_initialized"]
