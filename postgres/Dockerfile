# syntax=docker/dockerfile:1
FROM postgres:16.1 AS database

ENV TZ="Europe/Berlin"

COPY config /etc/postgresql

HEALTHCHECK --interval=2s --timeout=5s --retries=10 CMD pg_isready
