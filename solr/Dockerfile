# syntax=docker/dockerfile:1
FROM solr:9.7.0 AS builder

ENV TYPO3_SOLR=12.0.3 \
    TYPO3_SOLR_DOWNLOAD_SHA512="882f24a44d221f5d85a2066ab1235c9aedcd31c8a8f2009f9343b73de2931fd354fed6a8175fe18fa6fa0c284dd07d428c4f547f24875129e5a1d57c5ffd283f"

USER root

RUN apt-get update && \
    apt-get -y install wget tar && \
    SOLR_DOWNLOAD_URL="https://github.com/TYPO3-Solr/ext-solr/archive/${TYPO3_SOLR}.tar.gz" && \
    wget -t 10 --max-redirect 4 --retry-connrefused -nv "$SOLR_DOWNLOAD_URL" -O "/tmp/solr.tar.gz" && \
    sha512sum /tmp/solr.tar.gz && \
    echo "$TYPO3_SOLR_DOWNLOAD_SHA512 /tmp/solr.tar.gz" | sha512sum -c - && \
    mkdir -p /tmp/solr && \
    tar -zxvf /tmp/solr.tar.gz -C /tmp/solr --strip-components=1;

FROM solr:9.6.1 AS solr
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
  && apt update && apt upgrade -y && apt install sudo -y \
  && echo "# EXT:solr relevant changes: " >> /etc/default/solr.in.sh \
    && echo "SOLR_ENABLE_REMOTE_STREAMING=true" >> /etc/default/solr.in.sh \
    && echo "SOLR_ENABLE_STREAM_BODY=true" >> /etc/default/solr.in.sh \
    && echo "# END: EXT:solr" >> /etc/default/solr.in.sh

USER solr

COPY --from=builder --chown=solr:solr /tmp/solr/Resources/Private/Solr/ /var/solr/data
RUN mkdir -p /var/solr/data/data

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl -s -A 'healthcheck' http://localhost:$SOLR_PORT/solr/$HEALTHCHECK_CORE/admin/ping?wt=json | grep -q '"status":"OK"'
