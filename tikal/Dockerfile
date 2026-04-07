FROM ubuntu:26.04 AS base

ARG OKAPI_VERSION=1.48.0

RUN apt-get update && apt-get install -y unzip ca-certificates && rm -rf /var/lib/apt/lists/*

ADD "https://okapiframework.org/binaries/main/${OKAPI_VERSION}/okapi-apps_gtk2-linux-x86_64_${OKAPI_VERSION}.zip" /tmp/okapi.zip

RUN unzip /tmp/okapi.zip -d /opt/okapi

FROM openjdk:27-ea-trixie AS okapi

COPY --from=base /opt/okapi /opt/okapi

RUN chmod +x /opt/okapi/tikal.sh

WORKDIR /data

ENTRYPOINT ["/opt/okapi/tikal.sh"]
