ARG PHP_VERSION=8.4

FROM dunglas/frankenphp:builder-php${PHP_VERSION} AS app-frankenphp-builder
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

RUN CGO_ENABLED=1 \
    XCADDY_SETCAP=1 \
    XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx" \
    CGO_CFLAGS=$(php-config --includes) \
    CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
    xcaddy build \
        --output /usr/local/bin/frankenphp \
        --with github.com/dunglas/frankenphp=./ \
        --with github.com/dunglas/frankenphp/caddy=./caddy/ \
        --with github.com/dunglas/caddy-cbrotli \
        --with github.com/dunglas/vulcain/caddy \
        --with github.com/lolPants/caddy-requestid

FROM dunglas/frankenphp:php${PHP_VERSION} AS app-frankenphp-base
RUN <<EOF
    set -e
    apt-get update -y
    apt-get -y install --no-install-suggests --no-install-recommends \
        cron \
        ghostscript \
        imagemagick \
        nano \
        openssl \
        supervisor \
        tar \
        unzip \
        vim \
        webp \
        zip
EOF

RUN <<EOF
    set -e
    install-php-extensions \
        amqp \
        apcu \
        bcmath \
        bz2 \
        curl \
        ffi \
        gd \
        gmp \
        igbinary \
        imagick \
        intl \
        mbstring \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pgsql \
        raphf \
        readline \
        redis \
        soap \
        sockets \
        sqlite3 \
        xml \
        yaml \
        zip \
        zstd
    apt-get autoremove
EOF

COPY --from=ghcr.io/tideways/cli:latest /usr/bin/tideways /usr/bin/tideways
COPY --from=ghcr.io/tideways/php:latest /tideways/ /tideways/
RUN set -ex; \
    docker-php-ext-enable --ini-name tideways.ini "$(php /tideways/get-ext-path.php)";

RUN <<EOF
  mkdir -p /var/www
  mkdir -p /var/www/var/chromium
  setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp;
  chown -R www-data:www-data /data/caddy
  chown -R www-data:www-data /config/caddy
  chown -R www-data:www-data /etc/frankenphp
  chown -R www-data:www-data /var/www
  rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
EOF

ENV PHP_VERSION=${PHP_VERSION} \
    PHP_ERROR_REPORTING=E_ALL \
    PHP_DISPLAY_ERRORS=0 \
    PHP_DISPLAY_STARTUP_ERRORS=0 \
    PHP_MEMORY_LIMIT=512m \
    PHP_MAX_EXECUTION_TIME=300 \
    PHP_MAX_INPUT_VARS=1500 \
    PHP_ASSERT=-1 \
    PHP_POST_MAX_SIZE=128m \
    PHP_UPLOAD_MAX_FILESIZE=128m \
    PHP_MAX_FILE_UPLOADS=30 \
    PHP_OPCACHE_ENABLE_FILE_OVERRIDE=1 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=20 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=128 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=10000 \
    PHP_OPCACHE_PRELOAD_USER=www-data \
    PHP_OPCACHE_ENABLE_CLI=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_FILE_CACHE="" \
    PHP_OPCACHE_FILE_CACHE_ONLY=0 \
    PHP_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_REALPATH_CACHE_TTL=3600 \
    PHP_REALPATH_CACHE_SIZE=4M \
    PHP_XDEBUG_HOST=host.docker.internal \
    PHP_XDEBUG_MODE=off \
    PHP_SESSION_COOKIE_LIFETIME=0 \
    PHP_SESSION_HANDLER=files \
    PHP_SESSION_SAVE_PATH="" \
    PHP_SESSION_GC_MAXLIFETIME=1440 \
    COMPOSER_CACHE_DIR=/.cache/composer/ \
    TIDEWAYS_APIKEY="" \
    TIDEWAYS_DAEMON="tcp://tideways-daemon:9135" \
    TIDEWAYS_SAMPLERATE=25

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY ./config/conf.d/ /usr/local/etc/php/conf.d/

WORKDIR /var/www

COPY --chown=www-data:www-data ./config/caddy/*.caddyfile /etc/frankenphp/Caddyfile.d/
USER www-data

RUN frankenphp adapt --config /etc/frankenphp/Caddyfile --pretty --validate

HEALTHCHECK --interval=2s --timeout=2s --start-period=2s --retries=3 \
  CMD curl --fail --silent http://localhost:8080/health-check || exit 1

FROM app-frankenphp-base AS frankenphp
COPY --chown=www-data:www-data . /var/www/

FROM frankenphp AS frankenphp-cli
ENTRYPOINT [ "frankenphp", "php-cli" ]
CMD []


FROM app-frankenphp-base AS frankenphp-base-dev

USER root

ENV PHP_XDEBUG_HOST=host.docker.internal \
    PHP_XDEBUG_MODE=off

RUN <<EOF
    set -e
    apt-get update
    apt-get upgrade -y
    install-php-extensions xdebug
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
EOF

RUN <<EOF
cat > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini << 'EOL'
[xdebug]
zend_extension=xdebug.so
xdebug.client_host=${PHP_XDEBUG_HOST}
xdebug.client_port=9003
xdebug.mode=${PHP_XDEBUG_MODE}
xdebug.start_with_request=yes
xdebug.idekey=PHPSTORM
xdebug.log_level=1
xdebug.log=/var/log/xdebug.log
xdebug.max_nesting_level=1000
EOL
EOF

USER www-data

FROM frankenphp-base-dev AS frankenphp-dev

FROM frankenphp-base-dev AS frankenphp-cli-dev
ENTRYPOINT [ "frankenphp", "php-cli" ]
CMD []