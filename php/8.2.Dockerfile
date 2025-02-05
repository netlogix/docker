# syntax=docker/dockerfile:1
ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION} AS base
ARG PHP_VERSION=8.2
ARG XDEBUG_VERSION=3.4.0

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG="C.UTF-8"

ENV PHP_VERSION=${PHP_VERSION} \
    PHP_MEMORY_LIMIT=128m \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_INPUT_VARS=1500 \
    PHP_ASSERT=-1 \
    PHP_POST_MAX_SIZE=100M \
    PHP_UPLOAD_MAX_FILESIZE=100M \
    PHP_OPCACHE_ENABLE_FILE_OVERRIDE=0 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=8 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128M \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
    PHP_OPCACHE_PRELOAD_USER=www-data \
    PHP_REALPATH_CACHE_TTL=512 \
    PHP_XDEBUG_HOST=host.docker.internal \
    PHP_XDEBUG_MODE=off \
    XDEBUG_VERSION=${XDEBUG_VERSION} \
    TIDEWAYS_APIKEY="" \
    TIDEWAYS_DAEMON="tcp://tideways-daemon:9135" \
    TIDEWAYS_SAMPLERATE=25

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        software-properties-common \
        apt-transport-https \
        libfcgi-bin \
        ca-certificates \
        curl \
        gnupg2 \
        locales

RUN echo 'deb [signed-by=/usr/share/keyrings/tideways.gpg] https://packages.tideways.com/apt-packages-main any-version main' | tee /etc/apt/sources.list.d/tideways.list && \
    curl -L -sS 'https://packages.tideways.com/key.gpg' | gpg --dearmor | tee /usr/share/keyrings/tideways.gpg > /dev/null

RUN add-apt-repository ppa:ondrej/php -y

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        cron \
        ghostscript \
        gifsicle \
        imagemagick \
        jpegoptim \
        nano \
        openssl \
        optipng \
        pngquant \
        supervisor \
        tar \
        unzip \
        webp \
        zip \
        php${PHP_VERSION} \
        php${PHP_VERSION}-amqp \
        php${PHP_VERSION}-apcu \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-igbinary \
        php${PHP_VERSION}-imagick \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-readline \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-yaml \
        php${PHP_VERSION}-zip \
        tideways-php \
        tideways-cli \
    && apt-get autoremove \
    && find /var/log -type f -name "*.log" -delete \
    && rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache \
    && rm -rf /etc/cron.*/*

# Install locales
RUN locale-gen de_DE.UTF-8 && \
    locale-gen en_GB.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    locale-gen es_ES.UTF-8 && \
    locale-gen fr_FR.UTF-8 && \
    locale-gen nl_NL.UTF-8 && \
    locale-gen pt_PT.UTF-8 && \
    locale-gen it_IT.UTF-8

# Install dev certificates
COPY certs/* /usr/share/ca-certificates/netlogix/
RUN echo "netlogix/docker-dev-ca.crt" >> /etc/ca-certificates.conf && update-ca-certificates

RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm

RUN mkdir -p "/run/php/" \
    && chown -R www-data:www-data /run/php/ \
    && chmod 755 /run/php/ \
    && touch /var/log/xdebug.log \
    && chown www-data:www-data /var/log/xdebug.log

RUN touch /var/run/supervisord.pid \
    && chown www-data:www-data /var/run/supervisord.pid

# Config files
COPY config/conf.d /etc/php/${PHP_VERSION}/cli/conf.d/
COPY config/conf.d /etc/php/${PHP_VERSION}/fpm/conf.d/
COPY config/fpm/pool.d /etc/php/${PHP_VERSION}/fpm/pool.d/
COPY config/fpm-${PHP_VERSION}/pool.d /etc/php/${PHP_VERSION}/fpm/pool.d/

# Config files
COPY dev/bash /root/

# Test php-fpm config and php info
RUN php-fpm -tt
RUN php -i

WORKDIR /var/www

FROM base AS php-fpm

COPY fpm /usr/local/bin/

STOPSIGNAL SIGTERM
EXPOSE 9000

HEALTHCHECK --interval=2s --timeout=5s --retries=10 CMD php-fpm-healthcheck || exit 1
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]

FROM base AS php-cli

STOPSIGNAL SIGTERM

ENV PHP_MEMORY_LIMIT=-1 \
    PHP_MAX_EXECUTION_TIME=-1

COPY cli/docker-php-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]

FROM php-cli AS php-cron

WORKDIR /var/www

COPY --chmod=0755 cron/docker-cron-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-cron-entrypoint"]
CMD ["cron", "-f", "-l", "2"]

FROM php-cli AS php-supervisor

COPY supervisor/docker-supervisor-entrypoint /usr/local/bin/
COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf

USER www-data

ENTRYPOINT ["docker-supervisor-entrypoint"]
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

# Dev PHP fpm
FROM php-fpm AS php-fpm-dev

ENV PHP_ASSERT=1 \
    COMPOSER_CACHE_DIR=/.cache/composer/ \
    YARN_CACHE_FOLDER=/.cache/yarn/ \
    npm_config_cache=/.cache/npm/ \
    TERM=xterm-256color \
    TIDEWAYS_DAEMON=""

# enable debugging with PhpStorm
ENV PHP_IDE_CONFIG="serverName=localhost"

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
      make php${PHP_VERSION}-dev php-pear openssh-client git patch \
    && mkdir -p /tmp/pear/cache \
    && pecl channel-update pecl.php.net \
    && pecl install xdebug-${XDEBUG_VERSION} \
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

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY dev/scripts /usr/local/bin/

# Dev PHP cli
FROM php-fpm-dev AS php-cli-dev

STOPSIGNAL SIGTERM

ENV PHP_MEMORY_LIMIT=-1
ENV PHP_MAX_EXECUTION_TIME=-1

COPY cli/docker-php-entrypoint /usr/local/bin/

# Disabling the health check of the descendant php-fpm-dev image, since the production php-cron image does neither have a healthcheck.
HEALTHCHECK NONE
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]

# Dev PHP cron
FROM php-cli-dev AS php-cron-dev

WORKDIR /var/www

COPY --chmod=0755 cron/docker-cron-entrypoint /usr/local/bin/

# Disabling the health check of the descendant php-fpm-dev image, since the production php-cron image does neither have a healthcheck.
HEALTHCHECK NONE
ENTRYPOINT ["docker-cron-entrypoint"]
CMD ["cron", "-f", "-l", "2"]
