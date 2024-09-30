# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.23-alpine AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='1.6.1'

WORKDIR /src

RUN apk --no-cache add ca-certificates git
RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/jonnenauha/prometheus_varnish_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/varnish_exporter

FROM alpine:3.20 AS prometheus-varnish-exporter

RUN apk add --no-cache docker-cli
COPY --from=builder /out/* /

# Run as non-root user for secure environments
USER 59000:59000

EXPOSE 9131
ENTRYPOINT [ "/varnish_exporter" ]
