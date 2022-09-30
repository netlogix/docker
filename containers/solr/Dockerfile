# syntax=docker/dockerfile:1
FROM solr:8.11.2 as builder

ENV TYPO3_SOLR=11.5.0

USER root
RUN set -ex; \
    apt-get update; \
    apt-get -y install wget unzip; \
    SOLR_DOWNLOAD_URL="https://github.com/TYPO3-Solr/ext-solr/releases/download/$TYPO3_SOLR/solr_$TYPO3_SOLR.zip"; \
    wget -t 10 --max-redirect 4 --retry-connrefused -nv "$SOLR_DOWNLOAD_URL" -O "/tmp/solr.zip"; \
    unzip /tmp/solr.zip -d /tmp/solr;

FROM solr:8.11.2

USER root
RUN rm -fR /opt/solr/server/solr/*
USER solr

COPY --from=builder --chown=solr:solr /tmp/solr/Resources/Private/Solr /var/solr/data
RUN mkdir -p /var/solr/data/data

ENV SOLR_LOG_LEVEL=WARN
