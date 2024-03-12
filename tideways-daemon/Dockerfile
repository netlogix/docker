# https://support.tideways.com/documentation/setup/installation/docker-with-compose.html
FROM debian:bookworm-slim AS tideways-daemon

ENV TIDEWAYS_ENVIRONMENT=production \
    TIDEWAYS_VERSION=1.8.42

RUN useradd --system tideways
RUN apt-get update && apt-get install -yq --no-install-recommends gnupg2 curl ca-certificates

RUN echo 'deb https://packages.tideways.com/apt-packages-main any-version main' > /etc/apt/sources.list.d/tideways.list && \
    curl -L -sS 'https://packages.tideways.com/key.gpg' | apt-key add -
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get -y install --no-install-suggests --no-install-recommends tideways-daemon=${TIDEWAYS_VERSION} \
    && apt-get autoremove --assume-yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9135

USER tideways

ENTRYPOINT ["tideways-daemon", "--hostname=tideways-daemon", "--address=0.0.0.0:9135"]
