FROM ghcr.io/dexidp/dex:v2.44.0 AS dex

HEALTHCHECK  --interval=30s --timeout=5s --start-period=10s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5556/dex/.well-known/openid-configuration || exit 1
