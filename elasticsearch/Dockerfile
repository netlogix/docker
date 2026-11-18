# syntax=docker/dockerfile:1
ARG ELASTICSEARCH_VERSION
FROM elasticsearch:${ELASTICSEARCH_VERSION} AS elasticsearch

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV logger.level=WARN
# Mitigation for CVE-2026-114938 (Java4Shell), remove once the bundled JDK is patched; JAVA_TOOL_OPTIONS is ignored here
COPY <<EOF /usr/share/elasticsearch/config/jvm.options.d/java4shell.options
-XX:-UseBASE64Intrinsics
EOF

ADD analysis /usr/share/elasticsearch/config/analysis/
HEALTHCHECK --interval=10s --timeout=5s --start-period=120s --start-interval=2s --retries=3 CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
