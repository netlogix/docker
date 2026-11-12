# syntax=docker/dockerfile:1
FROM varnish:9.1 AS varnish

ENV VARNISH_SIZE=1G

USER root

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

COPY config /etc/varnish/

COPY docker-varnish-entrypoint /usr/local/bin/

USER varnish
HEALTHCHECK --interval=10s --timeout=3s --start-period=60s --start-interval=2s --retries=3 CMD wget -qO- http://localhost:80/health | grep -q 'health'
