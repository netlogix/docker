# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.19-alpine3.16 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN apk add --no-cache git && \
    git clone https://github.com/dfeyer/flow-debugproxy.git .

RUN go mod download

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/flow-debugproxy .

FROM alpine:3.16 AS flow-debugproxy

ENV XDEBUG_PORT=9003 \
    IDE_HOST=host.docker.internal \
    IDE_PORT=9000 \
    CONTEXT=Development/Docker \
    FRAMEWORK=flow \
    ADDITIONAL_ARGS=''

WORKDIR /app

COPY --from=builder /out/flow-debugproxy /app

ENTRYPOINT ["sh", "-c", "./flow-debugproxy --xdebug 0.0.0.0:${XDEBUG_PORT} --ide ${IDE_HOST}:${IDE_PORT} --context ${CONTEXT} --framework ${FRAMEWORK} ${ADDITIONAL_ARGS}"]