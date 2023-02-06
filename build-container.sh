#!/bin/bash

set -eu -o pipefail

if [ "${VERSION:-}" = "" ]; then
  #export VERSION=$(git describe --tags --always --dirty)
  export VERSION=latest
fi

docker buildx build -t serverspec:${VERSION} -f serverspec/Dockerfile serverspec

docker buildx build -t mariadb:${VERSION} -f mariadb/Dockerfile mariadb
docker buildx build -t mysql:${VERSION} -f mysql/Dockerfile mysql
docker buildx build -t proxy:${VERSION} -f proxy/Dockerfile proxy
docker buildx build -t rabbitmq:${VERSION} -f rabbitmq/Dockerfile rabbitmq
docker buildx build -t redis:${VERSION} -f redis/Dockerfile redis
docker buildx build -t solr:${VERSION} -f solr/Dockerfile solr
docker buildx build -t varnish:${VERSION} -f varnish/Dockerfile varnish
docker buildx build -t elasticsearch:${VERSION} -f elasticsearch/Dockerfile elasticsearch
docker buildx build -t styleguide:${VERSION} -f styleguide/Dockerfile styleguide
docker buildx build -t webserver-neos:${VERSION} -f webserver/Dockerfile --target=webserver-neos webserver
docker buildx build -t webserver-static:${VERSION} -f webserver/Dockerfile --target=webserver-static webserver
docker buildx build -t webserver-typo3:${VERSION} -f webserver/Dockerfile --target=webserver-typo3 webserver
docker buildx build -t webserver-shopware:${VERSION} -f webserver/Dockerfile --target=webserver-shopware webserver
docker buildx build -t chromium:${VERSION} -f chromium/Dockerfile chromium
docker buildx build -t mailhog:${VERSION} -f mailhog/Dockerfile mailhog
docker buildx build -t cfssl:${VERSION} -f cfssl/Dockerfile --target=cfssl cfssl
docker buildx build -t cfssl-server:${VERSION} -f cfssl/Dockerfile --target=cfssl-server cfssl
docker buildx build -t tideways-daemon:${VERSION} -f tideways-daemon/Dockerfile tideways-daemon
docker buildx build -t docker-proxy:${VERSION} -f docker-proxy/Dockerfile docker-proxy

docker buildx build -t php-fpm:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t php-cli:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t php-fpm-dev:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t php-cli-dev:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t php-cron:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t php-supervisor:7.2 --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t php-fpm:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t php-cli:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t php-fpm-dev:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t php-cli-dev:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t php-cron:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t php-supervisor:7.4 --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t php-fpm:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-fpm php
docker buildx build -t php-cli:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cli php
docker buildx build -t php-fpm-dev:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-fpm-dev php
docker buildx build -t php-cli-dev:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cli-dev php
docker buildx build -t php-cron:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-cron php
docker buildx build -t php-supervisor:8.1 --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f php/Dockerfile --target=php-supervisor php

docker buildx build -t php-fpm:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=22.04 -f php/8.2.dockerfile --target=php-fpm php
docker buildx build -t php-cli:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=22.04 -f php/8.2.dockerfile --target=php-cli php
docker buildx build -t php-fpm-dev:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=22.04 -f php/8.2.dockerfile --target=php-fpm-dev php
docker buildx build -t php-cli-dev:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=22.04 -f php/8.2.dockerfile --target=php-cli-dev php
docker buildx build -t php-cron:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=22.04 -f php/8.2.dockerfile --target=php-cron php
docker buildx build -t php-supervisor:8.2 --build-arg PHP_VERSION=8.2 --build-arg UBUNTU_VERSION=22.04 -f php/8.2.dockerfile --target=php-supervisor php
