# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.20-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='v2.2.0'

WORKDIR /src

RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/hipages/php-fpm_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/php-fpm_exporter

FROM alpine:3.17 AS prometheus-php-fpm-exporter

COPY --from=builder /out/* /

EXPOSE 9253
ENTRYPOINT [ "/php-fpm_exporter", "server" ]
