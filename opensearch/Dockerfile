FROM opensearchproject/opensearch:2.19.2 AS opensearch

ENV discovery.type=single-node
ENV bootstrap.memory_lock=true
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"
ENV logger.level=WARN
ENV plugins.security.ssl.http.enabled=false

ARG JQ_VERSION=1.7
ADD --chmod=755 https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-linux64 /usr/bin/jq
HEALTHCHECK --interval=1s --timeout=5s --retries=60 CMD if [ "$(curl --silent --fail -u admin:${OPENSEARCH_INITIAL_ADMIN_PASSWORD} localhost:9200/_cluster/health | jq .number_of_nodes)" -gt 0 ]; then exit 0; else exit 1; fi
