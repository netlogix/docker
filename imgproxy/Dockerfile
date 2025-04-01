FROM ghcr.io/imgproxy/imgproxy:v3.28 AS imgproxy
ENV IMGPROXY_LOCAL_FILESYSTEM_ROOT=/var/www/public
USER root
RUN install -d -o imgproxy -g imgproxy /var/www/public
USER imgproxy
WORKDIR /var/www

HEALTHCHECK --interval=10s --timeout=10s --retries=3 CMD imgproxy health
