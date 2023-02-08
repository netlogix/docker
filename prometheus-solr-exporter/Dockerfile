# syntax=docker/dockerfile:1
FROM solr:9.1.1 AS prometheus-solr-exporter

ENV JAVA_HEAP=64M

EXPOSE 9854
ENTRYPOINT [ "/opt/solr/prometheus-exporter/bin/solr-exporter", "-p", "9854", "-f", "/opt/solr/prometheus-exporter/conf/solr-exporter-config.xml", "-n", "8" ]
