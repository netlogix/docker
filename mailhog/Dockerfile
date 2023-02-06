# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM golang:1.20-bullseye AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

RUN git clone -b 'v1.1.0-beta1' --single-branch --depth 1 https://github.com/mailhog/MailHog.git .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/mailhog .

FROM gcr.io/distroless/static-debian11:nonroot AS mailhog

COPY --from=builder /out/mailhog /

CMD ["/mailhog"]
EXPOSE 1025 8025
