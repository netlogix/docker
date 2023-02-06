# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.20-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='v0.11.0'

WORKDIR /src

RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/nginxinc/nginx-prometheus-exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/nginx_exporter

FROM alpine:3.17 AS prometheus-nginx-exporter

COPY --from=builder /out/* /

EXPOSE 9113
ENTRYPOINT [ "/nginx_exporter" ]
