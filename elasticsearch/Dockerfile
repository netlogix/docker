# syntax=docker/dockerfile:1
FROM elasticsearch:9.5.5 AS elasticsearch

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV logger.level=WARN

ADD analysis /usr/share/elasticsearch/config/analysis/
HEALTHCHECK --interval=30s --timeout=20s --start-period=120s --start-interval=2s --retries=3 CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
