# syntax=docker/dockerfile:1
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION} as base
ARG PHP_VERSION=8.1
ENV DEBIAN_FRONTEND=noninteractive

ENV PHP_MEMORY_LIMIT=128m
ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MAX_INPUT_VARS=1500
ENV PHP_ASSERT=-1
ENV PHP_XDEBUG_MODE=off

ENV TZ=UTC
ENV LANG="C.UTF-8"

RUN set -eux; \
    apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        ca-certificates \
        curl \
        tar \
        openssl \
        imagemagick \
        jpegoptim \
        optipng \
        pngquant \
        unzip \
        zip \
        php${PHP_VERSION}-apcu \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-igbinary \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-readline \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-yaml \
        php${PHP_VERSION}-zip \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Config files
COPY config/cli/conf.d /etc/php/${PHP_VERSION}/cli/conf.d/
COPY config/fpm/pool.d /etc/php/${PHP_VERSION}/fpm/pool.d/
COPY config/cli/conf.d/99-php.ini /etc/php/${PHP_VERSION}/fpm/conf.d/99-php.ini

WORKDIR /var/www

FROM base AS php-fpm

COPY fpm/docker-php-entrypoint /usr/local/bin/

STOPSIGNAL SIGQUIT
EXPOSE 9000

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]

FROM base AS php-cli

ENV PHP_MEMORY_LIMIT=-1
ENV PHP_MAX_EXECUTION_TIME=-1

COPY cli/docker-php-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]

FROM php-cli AS php-cron

RUN set -eux; \
    apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
      cron \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ['crond', '-f', '-l', '8']
CMD ['crond', '-f', '-l', '8']

FROM php-fpm AS php-fpm-dev

ENV PHP_ASSERT=1

RUN set -eux; \
    apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
      php${PHP_VERSION}-xdebug \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

FROM php-cli AS php-cli-dev

ENV PHP_ASSERT=1

RUN set -eux; \
    apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
      php${PHP_VERSION}-xdebug \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*
