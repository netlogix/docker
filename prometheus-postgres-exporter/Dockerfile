# syntax=docker/dockerfile:1
# renovate: datasource=docker depName=quay.io/prometheuscommunity/postgres-exporter
ARG EXPORTER_VERSION=v0.20.1

FROM quay.io/prometheuscommunity/postgres-exporter:${EXPORTER_VERSION} AS source

FROM alpine:3.24 AS prometheus-postgres-exporter

COPY --from=source /bin/postgres_exporter /

# Run as non-root user for secure environments
USER 59000:59000

ENTRYPOINT [ "/postgres_exporter" ]
