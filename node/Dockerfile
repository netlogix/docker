# syntax=docker/dockerfile:1
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-slim AS node

# Install dev certificates
COPY certs/* /usr/share/ca-certificates/meggernet/
ENV NODE_EXTRA_CA_CERTS="/usr/share/ca-certificates/meggernet/docker-dev-ca.crt"