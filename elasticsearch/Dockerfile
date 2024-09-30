# syntax=docker/dockerfile:1
FROM elasticsearch:7.17.24 AS elasticsearch

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV logger.level=WARN

ADD analysis /usr/share/elasticsearch/config/analysis/
HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail localhost:9200/_cluster/health || exit 1
