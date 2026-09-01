# syntax=docker/dockerfile:1
FROM postgres:16.4 AS postgres

ENV TZ="Europe/Berlin"

COPY config /etc/postgresql

HEALTHCHECK --interval=2s --timeout=5s --retries=10 CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB
