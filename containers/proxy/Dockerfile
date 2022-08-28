# syntax=docker/dockerfile:1
FROM nginx:1.23.1

RUN apt-get update && apt-get install -y \
    nginx-extras \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64 -o /usr/local/bin/envsubst && chmod +x /usr/local/bin/envsubst

RUN unlink /etc/nginx/sites-enabled/default
COPY config /etc/nginx
COPY docker-entrypoint.d /docker-entrypoint.d
