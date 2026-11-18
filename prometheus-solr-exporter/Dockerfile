# syntax=docker/dockerfile:1
FROM solr:10.1.0 AS prometheus-solr-exporter

ENV JAVA_HEAP=64M
# Mitigation for CVE-2026-114938 (Java4Shell), remove once the bundled JDK is patched
ENV JAVA_TOOL_OPTIONS="-XX:-UseBASE64Intrinsics"

ENTRYPOINT [ "/opt/solr/prometheus-exporter/bin/solr-exporter", "-p", "9231", "-f", "/opt/solr/prometheus-exporter/conf/solr-exporter-config.xml" ]
