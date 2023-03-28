# syntax=docker/dockerfile:1
FROM varnish:6.6.2

ENV VARNISH_SIZE 1G

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

COPY config /etc/varnish/

COPY docker-varnish-entrypoint /usr/local/bin/

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD wget -qO- http://localhost:80/health | grep -q 'health'
