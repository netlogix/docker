# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.23-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN git clone -b 'v1.6.4' --single-branch --depth 1 https://github.com/cloudflare/cfssl.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/cfssl ./cmd/cfssl
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/cfssl-bundle ./cmd/cfssl-bundle
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/cfssl-certinfo ./cmd/cfssl-certinfo
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/cfssl-newkey ./cmd/cfssl-newkey
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/cfssl-scan ./cmd/cfssl-scan
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/cfssljson ./cmd/cfssljson
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/mkbundle ./cmd/mkbundle
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags "-s -w -X github.com/cloudflare/cfssl/cli/version.version=1.6.5" -o /out/multirootca ./cmd/multirootca

FROM alpine:3.20 AS cfssl-server

COPY --from=builder /out/* /

VOLUME /etc/cfssl

EXPOSE 8080

CMD ["/cfssl"]

FROM alpine:3.20 AS cfssl

COPY --from=builder /out/* /

CMD ["/cfssl"]
