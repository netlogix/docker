# syntax=docker/dockerfile:1
FROM nginx:1.23.4
COPY etc /etc/
RUN mkdir -p /var/www

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail http://127.0.0.1/health || exit 1
