# syntax=docker/dockerfile:1

ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm-alpine as base

ARG XDEBUG_VERSION=3.1.3
ENV XDEBUG_VERSION=${XDEBUG_VERSION}

ARG IMAGICK_VERSION=3.7.0
ENV IMAGICK_VERSION=${IMAGICK_VERSION}

ARG REDIS_VERSION=5.3.7
ENV REDIS_VERSION=${REDIS_VERSION}
# dependencies required for running "phpize"
# these get automatically installed and removed by "docker-php-ext-*" (unless they're already installed)
ENV BUILD_DEPS autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c wget bzip2-dev freetype-dev gettext-dev icu-dev imagemagick-dev jpeg-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev libressl-dev libwebp-dev libxml2-dev libxpm-dev oniguruma-dev

ENV PHP_MEMORY_LIMIT=128m
ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MAX_INPUT_VARS=1500
ENV PHP_ASSERT=0
ENV PHP_XDEBUG_MODE=off

RUN set -eux; \
    # Packages needed only for build
    apk add --no-cache --virtual .build-deps ${BUILD_DEPS} \
    # Packages to install
    && apk add --no-cache imagemagick imagemagick-libs jpegoptim libpng libtool libwebp-tools optipng pngquant zip libzip-dev icu-libs \
    # pecl PHP extensions
    && pecl install imagick-${IMAGICK_VERSION} xdebug-${XDEBUG_VERSION} redis-${REDIS_VERSION} \
    # Configure PHP extensions
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl --enable-intl \
    # Install PHP extensions
    && docker-php-ext-install -j$(nproc) bcmath exif gd intl mbstring mysqli opcache pdo_mysql zip \
    # Enable PHP extensions
    && docker-php-ext-enable imagick xdebug redis \
    # Remove the build deps
    && apk del .build-deps \
    # Clean out directories that don't need to be part of the image
    && rm -rf /tmp/* /var/tmp/*

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy the `zzz-docker-php.ini` file into place for php
COPY config/conf.d /usr/local/etc/php/conf.d/

# Copy the `zzz-docker-php-fpm.conf` file into place for php-fpm
COPY config/php-fpm.d /usr/local/etc/php-fpm.d/

FROM base AS php-fpm

FROM base AS php-cli

ENV PHP_MEMORY_LIMIT=-1
ENV PHP_MAX_EXECUTION_TIME=-1

COPY --from=php:cli-alpine /usr/local/bin/docker-php-entrypoint /usr/local/bin/docker-php-entrypoint

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]

FROM base AS php-cron
ENV PHP_MEMORY_LIMIT=-1
ENV PHP_MAX_EXECUTION_TIME=-1

ENTRYPOINT ['crond', '-f', '-l', '8']
CMD ['crond', '-f', '-l', '8']
