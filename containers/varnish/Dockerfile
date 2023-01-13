# syntax=docker/dockerfile:1
FROM varnish:6.6

COPY config /etc/varnish/

ARG VARNISH_EXPORTER_VERSION=1.6.1

RUN apt-get update && apt-get install -y curl --deb-frontend-noninteractive && cd /usr/local/bin \
    && curl -sL https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/${VARNISH_EXPORTER_VERSION}/prometheus_varnish_exporter-${VARNISH_EXPORTER_VERSION}.linux-amd64.tar.gz \
    | tar xz --strip-components=1

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD wget -qO- http://localhost:80/health | grep -q 'health'
