# syntax=docker/dockerfile:1
FROM nginx:1.25.5
ENV TZ="Europe/Berlin"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY etc /etc/
RUN mkdir -p /var/www

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail http://127.0.0.1:90/health || exit 1
