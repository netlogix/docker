# syntax=docker/dockerfile:1
ARG REDIS_VERSION
FROM redis:${REDIS_VERSION}-alpine AS redis

COPY redis.conf /usr/local/etc/redis/redis.conf

HEALTHCHECK --interval=10s --timeout=2s --start-period=60s --start-interval=2s --retries=3 CMD redis-cli ping
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
