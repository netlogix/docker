FROM ghcr.io/imgproxy/imgproxy:v4.0 AS imgproxy
ENV IMGPROXY_LOCAL_FILESYSTEM_ROOT=/var/www/public
# expose prometheus metrics on :8081/metrics (scraped by telegraf)
ENV IMGPROXY_PROMETHEUS_BIND=:8081
ENV IMGPROXY_PROMETHEUS_NAMESPACE=imgproxy
USER root
RUN install -d -o imgproxy -g imgproxy /var/www/public
USER imgproxy
WORKDIR /var/www

HEALTHCHECK --interval=10s --timeout=10s --retries=3 CMD imgproxy health
