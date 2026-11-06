# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.27-alpine AS builder

ARG TARGETOS
ARG TARGETARCH
# actively maintained fork of jonnenauha/prometheus_varnish_exporter (unmaintained since 1.6.1)
# renovate: datasource=github-releases depName=prometheus_varnish_exporter packageName=otto-de/prometheus_varnish_exporter
ARG EXPORTER_VERSION='v1.8.3'

WORKDIR /src

RUN apk --no-cache add ca-certificates git
RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/otto-de/prometheus_varnish_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-X main.Version=${EXPORTER_VERSION#v}" -o /out/varnish_exporter

FROM alpine:3.24 AS prometheus-varnish-exporter

RUN apk add --no-cache docker-cli
COPY --from=builder /out/* /

# Run as non-root user for secure environments
USER 59000:59000

ENTRYPOINT [ "/varnish_exporter" ]
