# syntax=docker/dockerfile:1
FROM postgres:16.15 AS postgres

ENV TZ="Europe/Berlin"

COPY config /etc/postgresql

HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --start-interval=2s --retries=3 CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB
