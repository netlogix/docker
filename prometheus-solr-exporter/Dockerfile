# syntax=docker/dockerfile:1
FROM solr:9.1.1 AS prometheus-solr-exporter

ENV JAVA_HEAP=48M
ENV SOLR_PORT=''

# Run as non-root user for secure environments
USER 59000:59000

EXPOSE 9231
ENTRYPOINT /opt/solr/prometheus-exporter/bin/solr-exporter -b http://solr:${SOLR_PORT}/solr/ -p 9231 -f /opt/solr/prometheus-exporter/conf/solr-exporter-config.xml -n 1
