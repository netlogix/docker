# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.20-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='1.6.1'

WORKDIR /src

RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/jonnenauha/prometheus_varnish_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/varnish_exporter


FROM alpine:3.17 AS prometheus-varnish-exporter

RUN apk add --no-cache docker-cli
COPY --from=builder /out/* /

EXPOSE 9253
ENTRYPOINT [ "/varnish_exporter" ]
