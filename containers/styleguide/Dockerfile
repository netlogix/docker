# syntax=docker/dockerfile:1

ARG NGINX_VERSION=1.22

FROM nginx:${NGINX_VERSION}
COPY sites-enabled/styleguide.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/www
