# syntax=docker/dockerfile:1
FROM redis:7.2.1-alpine

COPY redis.conf /usr/local/etc/redis/redis.conf

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD redis-cli ping
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
