# syntax=docker/dockerfile:1

ARG ELASTICSEARCH_VERSION=7.17.4
FROM elasticsearch:${ELASTICSEARCH_VERSION}

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV logger.level=WARN
