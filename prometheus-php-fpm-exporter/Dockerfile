# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.23-alpine AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='v2.2.0'

WORKDIR /src

RUN apk --no-cache add ca-certificates git
RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/hipages/php-fpm_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/php-fpm_exporter

FROM alpine:3.20 AS prometheus-php-fpm-exporter

COPY --from=builder /out/* /

# Run as non-root user for secure environments
USER 59000:59000

EXPOSE 9253
ENTRYPOINT [ "/php-fpm_exporter", "server" ]
