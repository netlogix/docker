FROM alpine:3.18 AS docker-proxy

RUN apk add --update --no-cache socat

ENTRYPOINT ["socat"]
CMD ["tcp-listen:2375,fork,reuseaddr", "unix-connect:/var/run/docker.sock"]
