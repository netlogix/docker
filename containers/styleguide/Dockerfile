# syntax=docker/dockerfile:1

ARG NGINX_VERSION=1.22

FROM nginx:${NGINX_VERSION}
COPY etc/ /etc/
RUN mkdir -p /var/www
