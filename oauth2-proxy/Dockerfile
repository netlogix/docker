FROM quay.io/oauth2-proxy/oauth2-proxy:v7.14.3-alpine AS oauth2-proxy

ENV TZ=Europe/Berlin

RUN apk add --no-cache ca-certificates tzdata

COPY certs/docker-dev-ca.crt /usr/local/share/ca-certificates/

RUN update-ca-certificates

HEALTHCHECK --interval=5s --timeout=5s --retries=3 \
    CMD wget -nv -t1 --spider 'http://127.0.0.1:4180/ready' || exit 1
