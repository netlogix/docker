# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.20-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='v0.12.0'

WORKDIR /src

RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/Lusitaniae/apache_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/apache_exporter

FROM alpine:3.17 AS prometheus-apache-exporter

COPY --from=builder /out/* /

EXPOSE 9117
ENTRYPOINT [ "/apache_exporter", "server" ]
