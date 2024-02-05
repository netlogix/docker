# syntax=docker/dockerfile:1
FROM postgres:14.10 AS database

ENV TZ="Europe/Berlin"

COPY config /etc/postgresql

HEALTHCHECK --interval=2s --timeout=5s --retries=10 CMD pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}
