#!/bin/bash

set -eu -o pipefail

if [ "${VERSION:-}" = "" ]; then
  #export VERSION=$(git describe --tags --always --dirty)
  export VERSION=latest
fi

docker buildx build -t mariadb:${VERSION} -f containers/mariadb/Dockerfile containers/mariadb
docker buildx build -t mysql:${VERSION} -f containers/mysql/Dockerfile containers/mysql
docker buildx build -t proxy:${VERSION} -f containers/proxy/Dockerfile containers/proxy
docker buildx build -t rabbitmq:${VERSION} -f containers/rabbitmq/Dockerfile containers/rabbitmq
docker buildx build -t redis:${VERSION} -f containers/redis/Dockerfile containers/redis
docker buildx build -t solr:${VERSION} -f containers/solr/Dockerfile containers/solr
docker buildx build -t varnish:${VERSION} -f containers/varnish/Dockerfile containers/varnish
docker buildx build -t elasticsearch:${VERSION} -f containers/elasticsearch/Dockerfile containers/elasticsearch
docker buildx build -t styleguide:${VERSION} -f containers/styleguide/Dockerfile containers/styleguide
docker buildx build -t webserver-neos:${VERSION} -f containers/webserver/Dockerfile --target=webserver-neos containers/webserver
docker buildx build -t webserver-static:${VERSION} -f containers/webserver/Dockerfile --target=webserver-static containers/webserver
docker buildx build -t flow-debugproxy:${VERSION} -f containers/flow-debugproxy/Dockerfile containers/flow-debugproxy
docker buildx build -t chromium:${VERSION} -f containers/chromium/Dockerfile containers/chromium
docker buildx build -t mailhog:${VERSION} -f containers/mailhog/Dockerfile containers/mailhog

docker buildx build -t php-7.2-fpm:${VERSION} --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f containers/php/Dockerfile --target=php-fpm containers/php
docker buildx build -t php-7.2-cli:${VERSION} --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f containers/php/Dockerfile --target=php-cli containers/php
docker buildx build -t php-7.2-fpm-dev:${VERSION} --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f containers/php/Dockerfile --target=php-fpm-dev containers/php
docker buildx build -t php-7.2-cli-dev:${VERSION} --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f containers/php/Dockerfile --target=php-cli-dev containers/php
docker buildx build -t php-7.2-cron:${VERSION} --build-arg PHP_VERSION=7.2 --build-arg UBUNTU_VERSION=18.04 -f containers/php/Dockerfile --target=php-cron containers/php

docker buildx build -t php-7.4-fpm:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-fpm containers/php
docker buildx build -t php-7.4-cli:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-cli containers/php
docker buildx build -t php-7.4-fpm-dev:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-fpm-dev containers/php
docker buildx build -t php-7.4-cli-dev:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-cli-dev containers/php
docker buildx build -t php-7.4-cron:${VERSION} --build-arg PHP_VERSION=7.4 --build-arg UBUNTU_VERSION=20.04 -f containers/php/Dockerfile --target=php-cron containers/php

docker buildx build -t php-8.1-fpm:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-fpm containers/php
docker buildx build -t php-8.1-cli:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-cli containers/php
docker buildx build -t php-8.1-fpm-dev:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-fpm-dev containers/php
docker buildx build -t php-8.1-cli-dev:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-cli-dev containers/php
docker buildx build -t php-8.1-cron:${VERSION} --build-arg PHP_VERSION=8.1 --build-arg UBUNTU_VERSION=22.04 -f containers/php/Dockerfile --target=php-cron containers/php
