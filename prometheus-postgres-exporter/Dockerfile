# syntax=docker/dockerfile:1
FROM alpine:3.23 AS prometheus-postgres-exporter

COPY --from=quay.io/prometheuscommunity/postgres-exporter /bin/postgres_exporter /

# Run as non-root user for secure environments
USER 59000:59000

ENTRYPOINT [ "/postgres_exporter" ]
