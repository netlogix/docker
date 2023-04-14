# syntax=docker/dockerfile:1
ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-slim AS node

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG="C.UTF-8"

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        ca-certificates \
        curl \
    && apt-get autoremove \
    && find /var/log -type f -name "*.log" -delete \
    && rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache

# Install dev certificates
COPY certs/* /usr/share/ca-certificates/netlogix/
RUN echo "netlogix/docker-dev-ca.crt" >> /etc/ca-certificates.conf && update-ca-certificates