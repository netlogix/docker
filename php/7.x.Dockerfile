# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv
FROM ubuntu:24.04 AS base
ARG PHP_VERSION=7.4
ARG XDEBUG_VERSION=3.1.6

ENV DEBIAN_FRONTEND=noninteractive \
    TZ="Europe/Berlin" \
    LANG="C.UTF-8" \
    TERM=xterm-256color

ENV PHP_VERSION=${PHP_VERSION} \
    PHP_ERROR_REPORTING=E_ALL&~E_NOTICE&~E_STRICT&~E_DEPRECATED \
    PHP_DISPLAY_ERRORS=1 \
    PHP_DISPLAY_STARTUP_ERRORS=0 \
    PHP_MEMORY_LIMIT=128m \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_INPUT_VARS=1500 \
    PHP_ASSERT=-1 \
    PHP_POST_MAX_SIZE=100M \
    PHP_UPLOAD_MAX_FILESIZE=100M \
    PHP_MAX_FILE_UPLOADS=30 \
    PHP_OPCACHE_ENABLE_FILE_OVERRIDE=0 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=8 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
    PHP_OPCACHE_PRELOAD_USER=www-data \
    PHP_OPCACHE_ENABLE_CLI=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_OPCACHE_FILE_CACHE=null \
    PHP_OPCACHE_FILE_CACHE_ONLY=0 \
    PHP_OPCACHE_REVALIDATE_FREQ=2 \
    PHP_REALPATH_CACHE_TTL=120 \
    PHP_REALPATH_CACHE_SIZE=4M \
    PHP_XDEBUG_HOST=host.docker.internal \
    PHP_XDEBUG_MODE=off \
    PHP_SESSION_COOKIE_LIFETIME=0 \
    PHP_SESSION_HANDLER=files \
    PHP_SESSION_SAVE_PATH="" \
    PHP_SESSION_GC_MAXLIFETIME=1440 \
    PHP_FPM_PM_MAX_CHILDREN=10 \
    PHP_FPM_PM_START_SERVERS=3 \
    PHP_FPM_PM_MIN_SPARE_SERVERS=2 \
    PHP_FPM_PM_MAX_SPARE_SERVERS=4 \
    PHP_FPM_PM_MAX_REQUESTS=1000 \
    XDEBUG_VERSION=${XDEBUG_VERSION}

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        software-properties-common \
        apt-transport-https \
        libfcgi-bin \
        ca-certificates \
        curl \
        gnupg2 \
        locales

RUN add-apt-repository ppa:ondrej/php -y

RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        cron \
        ghostscript \
        imagemagick \
        nano \
        openssl \
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
COPY config/bash /root/
COPY config/bash/.bashrc /etc/bash.bashrc

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
