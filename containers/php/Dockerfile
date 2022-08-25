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

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        ca-certificates \
        curl \
        gifsicle \
        imagemagick \
        jpegoptim \
        openssl \
        optipng \
        pngquant \
        tar \
        unzip \
        webp \
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
    && find /var/log -type f -name "*.log" -delete \
    && rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache

RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm

RUN mkdir -p "/run/php/" \
    && chown -R www-data:www-data /run/php/ \
    && chmod 755 /run/php/ \
    && touch /var/log/xdebug.log \
    && chown www-data:www-data /var/log/xdebug.log

# Config files
COPY config/conf.d /etc/php/${PHP_VERSION}/cli/conf.d/
COPY config/conf.d /etc/php/${PHP_VERSION}/fpm/conf.d/
COPY config/fpm/pool.d /etc/php/${PHP_VERSION}/fpm/pool.d/
COPY config/fpm-${PHP_VERSION}/pool.d /etc/php/${PHP_VERSION}/fpm/pool.d/

# Test php-fpm config and php info
RUN php-fpm -t
RUN php -i

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

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
      cron \
    && apt-get autoremove \
    && find /var/log -type f -name "*.log" -delete \
    && rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache

ENTRYPOINT ['crond']
CMD ['-f', '-l', '8']

FROM php-fpm AS php-fpm-dev

ENV PHP_ASSERT=1

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
      make php${PHP_VERSION}-dev php-pear \
    && mkdir -p /tmp/pear/cache \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-3.1.5 \
    && echo "zend_extension=xdebug.so" > /etc/php/${PHP_VERSION}/mods-available/xdebug.ini \
    && phpenmod xdebug \
    && apt-get -y autoremove --purge make php${PHP_VERSION}-dev php-pear \
    && apt-get autoremove \
    && find /var/log -type f -name "*.log" -delete \
    && rm -rf /root/.pearrc \
    && rm -rf /tmp/pear \
    && rm -rf /var/lib/php/modules/${PHP_VERSION}/cli/disabled_by_maint \
    && rm -rf /var/lib/php/modules/${PHP_VERSION}/fpm/disabled_by_maint \
    && rm -rf /usr/share/php/.registry /usr/share/php/.depdb /usr/share/php/.filemap \
    && rm -rf /usr/share/bug/file \
    && rm -rf /usr/share/doc/file \
    && rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache \
    && touch /var/log/xdebug.log \
    && chown www-data:www-data /var/log/xdebug.log

FROM php-fpm-dev AS php-cli-dev

ENV PHP_MEMORY_LIMIT=-1
ENV PHP_MAX_EXECUTION_TIME=-1

COPY cli/docker-php-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]
