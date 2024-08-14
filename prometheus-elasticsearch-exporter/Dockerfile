# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.23-alpine AS builder

ARG TARGETOS
ARG TARGETARCH
ARG EXPORTER_VERSION='v1.7.0'

WORKDIR /src

RUN apk --no-cache add ca-certificates git
RUN git clone -b $EXPORTER_VERSION --single-branch --depth 1 https://github.com/prometheus-community/elasticsearch_exporter.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/elasticsearch_exporter

FROM alpine:3.20 AS prometheus-elasticsearch-exporter

COPY --from=builder /out/* /

# Run as non-root user for secure environments
USER 59000:59000

EXPOSE 9114
ENTRYPOINT [ "/elasticsearch_exporter" ]
