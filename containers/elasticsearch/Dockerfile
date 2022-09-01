# syntax=docker/dockerfile:1
FROM elasticsearch:8.4.1

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV logger.level=WARN

ADD analysis/ /usr/share/elasticsearch/config/analysis/
