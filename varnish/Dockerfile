# syntax=docker/dockerfile:1
FROM varnish:7.7 AS varnish

ENV VARNISH_SIZE=1G

USER root

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

COPY config /etc/varnish/

COPY docker-varnish-entrypoint /usr/local/bin/

USER varnish
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD wget -qO- http://localhost:80/health | grep -q 'health'
