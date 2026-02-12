# syntax=docker/dockerfile:1
FROM solr:9.10.1 AS builder

ENV TYPO3_SOLR=13.1.1 \
    TYPO3_SOLR_DOWNLOAD_SHA512="5c5721aa385c73668ef1c40f047eb218eea06a6d0dbb45cfe91ee41f9d6c16b3923d5f3a5cc842e7a62a0342292ff9aea1fa294b6ffbac4a4ef96f8dc6137148"

USER root

RUN apt-get update && \
    apt-get -y install wget tar && \
    SOLR_DOWNLOAD_URL="https://github.com/TYPO3-Solr/ext-solr/archive/${TYPO3_SOLR}.tar.gz" && \
    wget -t 10 --max-redirect 4 --retry-connrefused -nv "$SOLR_DOWNLOAD_URL" -O "/tmp/solr.tar.gz" && \
    sha512sum /tmp/solr.tar.gz && \
    echo "$TYPO3_SOLR_DOWNLOAD_SHA512 /tmp/solr.tar.gz" | sha512sum -c - && \
    mkdir -p /tmp/solr && \
    tar -zxvf /tmp/solr.tar.gz -C /tmp/solr --strip-components=1;

FROM solr:9.10.1 AS solr
ENV TERM=linux \
    SOLR_LOG_LEVEL=WARN \
    SOLR_PORT=8983 \
    HEALTHCHECK_CORE=core_generic

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
