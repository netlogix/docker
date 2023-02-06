# syntax=docker/dockerfile:1
FROM varnish:6.6-alpine

COPY config /etc/varnish/

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD wget -qO- http://localhost:80/health | grep -q 'health'
