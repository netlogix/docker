# syntax=docker/dockerfile:1
FROM solr:9.8.1 AS prometheus-solr-exporter

ENV JAVA_HEAP=64M

EXPOSE 9231
ENTRYPOINT [ "/opt/solr/prometheus-exporter/bin/solr-exporter", "-p", "9231", "-f", "/opt/solr/prometheus-exporter/conf/solr-exporter-config.xml" ]
