# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.19-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN git clone https://github.com/dfeyer/flow-debugproxy.git .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/flow-debugproxy .

FROM gcr.io/distroless/static-debian11 AS flow-debugproxy

ENV XDEBUG_PORT=9003 \
    IDE_HOST=host.docker.internal \
    IDE_PORT=9000 \
    CONTEXT=Development/Docker \
    FRAMEWORK=flow \
    ADDITIONAL_ARGS=''

COPY --from=builder /out/flow-debugproxy /

COPY --from=busybox /bin/sh /bin/sh

ENTRYPOINT ["sh", "-c", "./flow-debugproxy --xdebug 0.0.0.0:${XDEBUG_PORT} --ide ${IDE_HOST}:${IDE_PORT} --context ${CONTEXT} --framework ${FRAMEWORK} ${ADDITIONAL_ARGS}"]
