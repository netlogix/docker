# syntax=docker/dockerfile:1
FROM solr:9.3.0 as builder

ENV TYPO3_SOLR=12.0.0 \
    TYPO3_SOLR_DOWNLOAD_SHA512="3bcf68ff22ad58c5ad58aac7d7569823ee53e9d42513592e43e1c295a8ed7c7cd8970506508f1702386321c62dc718e28a6957cceafa0509308fed8233d83d22"

USER root

RUN apt-get update && \
    apt-get -y install wget tar && \
    SOLR_DOWNLOAD_URL="https://github.com/TYPO3-Solr/ext-solr/archive/${TYPO3_SOLR}.tar.gz" && \
    wget -t 10 --max-redirect 4 --retry-connrefused -nv "$SOLR_DOWNLOAD_URL" -O "/tmp/solr.tar.gz" && \
    echo "$TYPO3_SOLR_DOWNLOAD_SHA512 /tmp/solr.tar.gz" | sha512sum -c - && \
    mkdir -p /tmp/solr && \
    tar -zxvf /tmp/solr.tar.gz -C /tmp/solr --strip-components=1;

RUN sed -i "s|name=core_|name=website-|i" /tmp/solr/Resources/Private/Solr/cores/*/core.properties \
    && cd /tmp/solr/Resources/Private/Solr/configsets/ext_solr_12_0_0/conf \
    && for f in _schema_analysis_*_core_*.json; do mv "$f" "$(echo "$f" | sed s/core_/website-/)"; done

FROM solr:9.3.0

ENV SOLR_LOG_LEVEL=WARN \
    SOLR_PORT=8983 \
    HEALTHCHECK_CORE=website-generic

USER root
RUN rm -fR /opt/solr/server/solr/*
USER solr

COPY --from=builder --chown=solr:solr /tmp/solr/Resources/Private/Solr /var/solr/data
RUN mkdir -p /var/solr/data/data

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl -s -A 'healthcheck' http://localhost:$SOLR_PORT/solr/$HEALTHCHECK_CORE/admin/ping?wt=json | grep -q '"status":"OK"'
