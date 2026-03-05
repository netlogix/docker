# syntax=docker/dockerfile:1
ARG REDIS_VERSION
FROM redis:${REDIS_VERSION}-alpine AS redis

COPY redis.conf /usr/local/etc/redis/redis.conf

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD redis-cli ping
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
