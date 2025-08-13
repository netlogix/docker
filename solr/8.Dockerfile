# syntax=docker/dockerfile:1
FROM solr:8.11.4 AS builder

ENV TYPO3_SOLR=11.5.7 \
    TYPO3_SOLR_DOWNLOAD_SHA512="11dadce1b557a00b7b726aa9279120637f49d4377c3d7260eb252f9f4fece8f7e30bbe640df24dbe7e085b7422b3e1b1bdd08d268cf044ea39563288001b78ee"

USER root
RUN apt-get update && \
    apt-get -y install wget tar && \
    SOLR_DOWNLOAD_URL="https://github.com/TYPO3-Solr/ext-solr/archive/${TYPO3_SOLR}.tar.gz" && \
    wget -t 10 --max-redirect 4 --retry-connrefused -nv "$SOLR_DOWNLOAD_URL" -O "/tmp/solr.tar.gz" && \
    sha512sum /tmp/solr.tar.gz && \
    echo "$TYPO3_SOLR_DOWNLOAD_SHA512 /tmp/solr.tar.gz" | sha512sum -c - && \
    mkdir -p /tmp/solr && \
    tar -zxvf /tmp/solr.tar.gz -C /tmp/solr --strip-components=1;

RUN sed -i "s|name=core_|name=website-|i" /tmp/solr/Resources/Private/Solr/cores/*/core.properties \
    && cd /tmp/solr/Resources/Private/Solr/configsets/ext_solr_11_5_0/conf \
    && for f in _schema_analysis_*_core_*.json; do mv "$f" "$(echo "$f" | sed s/core_/website-/)"; done

FROM solr:8.11.4 AS solr
ENV TERM=linux \
    SOLR_LOG_LEVEL=WARN \
    SOLR_PORT=8983 \
    HEALTHCHECK_CORE=website-generic

ARG SOLR_UNIX_UID="8983"
ARG SOLR_UNIX_GID="8983"

USER root
RUN rm -fR /opt/solr/server/solr/* \
  && usermod --non-unique --uid "${SOLR_UNIX_UID}" solr \
  && groupmod --non-unique --gid "${SOLR_UNIX_GID}" solr \
  && chown -R solr:solr /var/solr /opt/solr \
  && apt update && apt upgrade -y && apt install sudo -y

USER solr

COPY --from=builder --chown=solr:solr /tmp/solr/Resources/Private/Solr/ /var/solr/data
RUN mkdir -p /var/solr/data/data

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl -s -A 'healthcheck' http://localhost:$SOLR_PORT/solr/$HEALTHCHECK_CORE/admin/ping?wt=json | grep -q '"status":"OK"'

