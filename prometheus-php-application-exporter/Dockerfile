# syntax=docker/dockerfile:1
FROM nginx:1.27.5 AS prometheus-php-application-exporter
ENV TZ="Europe/Berlin"
ENV NGINX_ENTRYPOINT_QUIET_LOGS=1
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY etc /etc/

# Test nginx config
RUN nginx -t
