#!/bin/bash

set -eu -o pipefail

if [ "${VERSION:-}" = "" ]; then
  #export VERSION=$(git describe --tags --always --dirty)
  export VERSION=latest
fi

docker buildx build -t ghcr.io/netlogix/docker/serverspec:${VERSION} -f serverspec/Dockerfile serverspec

docker buildx build -t ghcr.io/netlogix/docker/mariadb:${VERSION} -f mariadb/Dockerfile mariadb
docker buildx build -t ghcr.io/netlogix/docker/mysql:${VERSION} -f mysql/Dockerfile mysql
docker buildx build -t ghcr.io/netlogix/docker/postgres:${VERSION} -f postgres/Dockerfile postgres
docker buildx build -t ghcr.io/netlogix/docker/prettier:${VERSION} -f prettier/Dockerfile prettier
docker buildx build -t ghcr.io/netlogix/docker/proxy:${VERSION} -f proxy/Dockerfile proxy
docker buildx build -t ghcr.io/netlogix/docker/rabbitmq:${VERSION} -f rabbitmq/Dockerfile rabbitmq
docker buildx build -t ghcr.io/netlogix/docker/redis:${VERSION} -f redis/Dockerfile redis
docker buildx build -t ghcr.io/netlogix/docker/solr:${VERSION} -f solr/Dockerfile solr
docker buildx build -t ghcr.io/netlogix/docker/varnish:${VERSION} -f varnish/Dockerfile varnish
docker buildx build -t ghcr.io/netlogix/docker/elasticsearch:${VERSION} -f elasticsearch/Dockerfile elasticsearch
docker buildx build -t ghcr.io/netlogix/docker/styleguide:${VERSION} -f styleguide/Dockerfile styleguide
docker buildx build -t ghcr.io/netlogix/docker/webserver-neos:${VERSION} -f webserver/Dockerfile --target=webserver-neos webserver
docker buildx build -t ghcr.io/netlogix/docker/webserver-static:${VERSION} -f webserver/Dockerfile --target=webserver-static webserver
docker buildx build -t ghcr.io/netlogix/docker/webserver-typo3:${VERSION} -f webserver/Dockerfile --target=webserver-typo3 webserver
docker buildx build -t ghcr.io/netlogix/docker/webserver-shopware:${VERSION} -f webserver/Dockerfile --target=webserver-shopware webserver
docker buildx build -t ghcr.io/netlogix/docker/chromium:${VERSION} -f chromium/Dockerfile chromium
docker buildx build -t ghcr.io/netlogix/docker/mailpit:${VERSION} -f mailpit/Dockerfile mailpit
docker buildx build -t ghcr.io/netlogix/docker/cfssl:${VERSION} -f cfssl/Dockerfile --target=cfssl cfssl
docker buildx build -t ghcr.io/netlogix/docker/cfssl-server:${VERSION} -f cfssl/Dockerfile --target=cfssl-server cfssl
docker buildx build -t ghcr.io/netlogix/docker/tideways-daemon:${VERSION} -f tideways-daemon/Dockerfile tideways-daemon

docker buildx build -t ghcr.io/netlogix/docker/prometheus-apache-exporter:${VERSION} -f prometheus-apache-exporter/Dockerfile prometheus-apache-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-elasticsearch-exporter:${VERSION} -f prometheus-elasticsearch-exporter/Dockerfile prometheus-elasticsearch-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-nginx-exporter:${VERSION} -f prometheus-nginx-exporter/Dockerfile prometheus-nginx-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-php-fpm-exporter:${VERSION} -f prometheus-php-fpm-exporter/Dockerfile prometheus-php-fpm-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-postgres-exporter:${VERSION} -f prometheus-postgres-exporter/Dockerfile prometheus-postgres-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-redis-exporter:${VERSION} -f prometheus-redis-exporter/Dockerfile prometheus-redis-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-solr-exporter:${VERSION} -f prometheus-solr-exporter/Dockerfile prometheus-solr-exporter
docker buildx build -t ghcr.io/netlogix/docker/prometheus-varnish-exporter:${VERSION} -f prometheus-varnish-exporter/Dockerfile prometheus-varnish-exporter

docker buildx build -t ghcr.io/netlogix/docker/php-fpm:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t ghcr.io/netlogix/docker/php-cli:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t ghcr.io/netlogix/docker/php-fpm-dev:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cli-dev:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cron:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t ghcr.io/netlogix/docker/php-cron-dev:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cron-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-supervisor:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t ghcr.io/netlogix/docker/php-fpm:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t ghcr.io/netlogix/docker/php-cli:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t ghcr.io/netlogix/docker/php-fpm-dev:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cli-dev:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cron:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t ghcr.io/netlogix/docker/php-cron-dev:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cron-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-supervisor:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t ghcr.io/netlogix/docker/php-fpm:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t ghcr.io/netlogix/docker/php-cli:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t ghcr.io/netlogix/docker/php-fpm-dev:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cli-dev:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cron:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t ghcr.io/netlogix/docker/php-cron-dev:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cron-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-supervisor:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t ghcr.io/netlogix/docker/php-fpm:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-fpm php
docker buildx build -t ghcr.io/netlogix/docker/php-cli:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-cli php
docker buildx build -t ghcr.io/netlogix/docker/php-fpm-dev:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-fpm-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cli-dev:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-cli-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cron:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-cron php
docker buildx build -t ghcr.io/netlogix/docker/php-cron-dev:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-cron-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-supervisor:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=24.04 -f php/8.2.dockerfile --target=php-supervisor php

docker buildx build -t ghcr.io/netlogix/docker/php-fpm:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t ghcr.io/netlogix/docker/php-cli:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t ghcr.io/netlogix/docker/php-fpm-dev:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cli-dev:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-cron:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t ghcr.io/netlogix/docker/php-cron-dev:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-cron-dev php
docker buildx build -t ghcr.io/netlogix/docker/php-supervisor:8.3 --build-arg PHP_VERSION=8.3 --build-arg UBUNTU_VERSION=24.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t ghcr.io/netlogix/docker/node:18 --build-arg NODE_VERSION=18 -f node/Dockerfile node
docker buildx build -t ghcr.io/netlogix/docker/node:20 --build-arg NODE_VERSION=20 -f node/Dockerfile node
