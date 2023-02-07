# syntax=docker/dockerfile:1
FROM solr:8.11.2 as builder

ENV TYPO3_SOLR=11.5.0 \
    TYPO3_SOLR_DOWNLOAD_SHA512="a0c0181993606dbaa587520e8aa8988f1b0eb845215828cf31df0dc181497ab4932db03359bc89655366197247210b4a82cbba1b7bcc5abba85545811e17eefe"

USER root
RUN set -ex; \
    apt-get update; \
    apt-get -y install wget unzip; \
    SOLR_DOWNLOAD_URL="https://github.com/TYPO3-Solr/ext-solr/releases/download/$TYPO3_SOLR/solr_$TYPO3_SOLR.zip"; \
    wget -t 10 --max-redirect 4 --retry-connrefused -nv "$SOLR_DOWNLOAD_URL" -O "/tmp/solr.zip"; \
    echo "$TYPO3_SOLR_DOWNLOAD_SHA512 /tmp/solr.zip" | sha512sum -c -; \
    unzip /tmp/solr.zip -d /tmp/solr;

RUN sed -i "s|name=core_|name=website-|i" /tmp/solr/Resources/Private/Solr/cores/*/core.properties \
    && cd /tmp/solr/Resources/Private/Solr/configsets/ext_solr_11_5_0/conf \
    && for f in _schema_analysis_*_core_*.json; do mv "$f" "$(echo "$f" | sed s/core_/website-/)"; done

FROM solr:8.11.2

ENV SOLR_LOG_LEVEL=WARN \
    HEALTHCHECK_CORE=website-generic

USER root
RUN rm -fR /opt/solr/server/solr/*
USER solr

COPY --from=builder --chown=solr:solr /tmp/solr/Resources/Private/Solr /var/solr/data
RUN mkdir -p /var/solr/data/data

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl -s -A 'healthcheck' http://localhost:$SOLR_PORT/solr/$HEALTHCHECK_CORE/admin/ping?wt=json | grep -q '"status":"OK"'

FROM solr:8.11.2

ENV JAVA_HEAP=32M

RUN contrib/prometheus-exporter/bin/solr-exporter -p 9231 -b http://localhost:8080/solr -f contrib/prometheus-exporter/conf/solr-exporter-config.xml

EXPOSE 9231
