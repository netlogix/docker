FROM quay.io/oauth2-proxy/oauth2-proxy:v7.12.0-alpine AS oauth2-proxy

ENV TZ=Europe/Berlin

RUN apk add --no-cache ca-certificates tzdata

COPY certs/docker-dev-ca.crt /usr/local/share/ca-certificates/

RUN update-ca-certificates