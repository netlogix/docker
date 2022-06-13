#!/bin/bash

set -eu -o pipefail

if [ "${VERSION:-}" = "" ]; then
  #export VERSION=$(git describe --tags --always --dirty)
  export VERSION=latest
fi

DOCKER_BUILDKIT=1 docker build -t mariadb:${VERSION} -f containers/mariadb/Dockerfile containers/mariadb
DOCKER_BUILDKIT=1 docker build -t proxy:${VERSION} -f containers/proxy/Dockerfile containers/proxy
DOCKER_BUILDKIT=1 docker build -t redis:${VERSION} -f containers/redis/Dockerfile containers/redis
DOCKER_BUILDKIT=1 docker build -t varnish:${VERSION} -f containers/varnish/Dockerfile containers/varnish
DOCKER_BUILDKIT=1 docker build -t elasticsearch:${VERSION} -f containers/elasticsearch/Dockerfile containers/elasticsearch
DOCKER_BUILDKIT=1 docker build -t styleguide:${VERSION} -f containers/styleguide/Dockerfile containers/styleguide
DOCKER_BUILDKIT=1 docker build -t webserver-neos:${VERSION} -f containers/webserver/Dockerfile --target=webserver-neos containers/webserver
DOCKER_BUILDKIT=1 docker build -t webserver-static:${VERSION} -f containers/webserver/Dockerfile --target=webserver-static containers/webserver

DOCKER_BUILDKIT=1 docker build -t php-7.4-fpm:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-fpm containers/php
DOCKER_BUILDKIT=1 docker build -t php-7.4-cli:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-cli containers/php
DOCKER_BUILDKIT=1 docker build -t php-7.4-fpm-dev:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-fpm-dev containers/php
DOCKER_BUILDKIT=1 docker build -t php-7.4-cli-dev:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-cli-dev containers/php
DOCKER_BUILDKIT=1 docker build -t php-7.4-cron:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-cron containers/php

DOCKER_BUILDKIT=1 docker build -t php-8.1-fpm:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-fpm containers/php
DOCKER_BUILDKIT=1 docker build -t php-8.1-cli:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-cli containers/php
DOCKER_BUILDKIT=1 docker build -t php-8.1-fpm-dev:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-fpm-dev containers/php
DOCKER_BUILDKIT=1 docker build -t php-8.1-cli-dev:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-cli-dev containers/php
DOCKER_BUILDKIT=1 docker build -t php-8.1-cron:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-cron containers/php
