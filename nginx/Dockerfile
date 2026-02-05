# syntax=docker/dockerfile:1
# Adding third-party modules to nginx official image
# SEE https://github.com/nginxinc/docker-nginx/tree/master/modules
FROM nginx:1.29.5 AS builder

ENV ENABLED_MODULES="headers-more subs-filter geoip2"
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

RUN if [ "$ENABLED_MODULES" = "" ]; then \
        echo "No additional modules enabled, exiting"; \
        exit 1; \
    fi

COPY ./ /modules/

RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
                patch make wget git devscripts debhelper dpkg-dev \
                quilt lsb-release build-essential libxml2-utils xsltproc \
                equivs git g++ libparse-recdescent-perl \
    && XSLSCRIPT_SHA512="f7194c5198daeab9b3b0c3aebf006922c7df1d345d454bd8474489ff2eb6b4bf8e2ffe442489a45d1aab80da6ecebe0097759a1e12cc26b5f0613d05b7c09ffa *stdin" \
    && wget -O /tmp/xslscript.pl https://raw.githubusercontent.com/nginx/xslscript/9204424259c343ca08a18a78915f40f28025e093/xslscript.pl \
    && if [ "$(cat /tmp/xslscript.pl | openssl sha512 -r)" = "$XSLSCRIPT_SHA512" ]; then \
        echo "XSLScript checksum verification succeeded!"; \
        chmod +x /tmp/xslscript.pl; \
        mv /tmp/xslscript.pl /usr/local/bin/; \
    else \
        echo "XSLScript checksum verification failed!"; \
        exit 1; \
    fi \
    && git clone -b ${NGINX_VERSION}-${PKG_RELEASE%%~*} https://github.com/nginx/pkg-oss/ \
    && cd pkg-oss \
    && mkdir /tmp/packages \
    && for module in $ENABLED_MODULES; do \
        echo "Building $module for nginx-$NGINX_VERSION"; \
        if [ -d /modules/$module ]; then \
            echo "Building $module from user-supplied sources"; \
            # check if module sources file is there and not empty
            if [ ! -s /modules/$module/source ]; then \
                echo "No source file for $module in modules/$module/source, exiting"; \
                exit 1; \
            fi; \
            # some modules require build dependencies
            if [ -f /modules/$module/build-deps ]; then \
                echo "Installing $module build dependencies"; \
                apt-get update && apt-get install -y --no-install-suggests --no-install-recommends $(cat /modules/$module/build-deps | xargs); \
            fi; \
            # if a module has a build dependency that is not in a distro, provide a
            # shell script to fetch/build/install those
            # note that shared libraries produced as a result of this script will
            # not be copied from the builder image to the main one so build static
            if [ -x /modules/$module/prebuild ]; then \
                echo "Running prebuild script for $module"; \
                /modules/$module/prebuild; \
            fi; \
            /pkg-oss/build_module.sh -v $NGINX_VERSION -f -y -o /tmp/packages -n $module $(cat /modules/$module/source); \
            BUILT_MODULES="$BUILT_MODULES $(echo $module | tr '[A-Z]' '[a-z]' | tr -d '[/_\-\.\t ]')"; \
        elif make -C /pkg-oss/debian list | grep -P "^$module\s+\d" > /dev/null; then \
            echo "Building $module from pkg-oss sources"; \
            cd /pkg-oss/debian; \
            make rules-module-$module BASE_VERSION=$NGINX_VERSION NGINX_VERSION=$NGINX_VERSION; \
            mk-build-deps --install --tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes" debuild-module-$module/nginx-$NGINX_VERSION/debian/control; \
            make module-$module BASE_VERSION=$NGINX_VERSION NGINX_VERSION=$NGINX_VERSION; \
            find ../../ -maxdepth 1 -mindepth 1 -type f -name "*.deb" -exec mv -v {} /tmp/packages/ \;; \
            BUILT_MODULES="$BUILT_MODULES $module"; \
        else \
            echo "Don't know how to build $module module, exiting"; \
            exit 1; \
        fi; \
    done \
    && echo "BUILT_MODULES=\"$BUILT_MODULES\"" > /tmp/packages/modules.env

# Build ModSecurity and ModSecurity-nginx connector for ModSecurity v3
# SEE: https://github.com/coreruleset/modsecurity-crs-docker/blob/main/nginx/Dockerfile
FROM nginx:1.29.5 AS modsecurity-builder

# renovate: datasource=github-releases depName=ModSecurity packageName=owasp-modsecurity/ModSecurity
ARG MODSECURITY_VERSION="v3.0.14"
# renovate: datasource=github-releases depName=ModSecurity-nginx packageName=owasp-modsecurity/ModSecurity-nginx
ARG MODSECURITY_NGINX_VERSION="v1.0.4"

USER root

RUN set -eux; \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections; \
    apt-get update -qq; \
    apt-get install -y -qq --no-install-recommends --no-install-suggests \
        automake \
        ca-certificates \
        cmake \
        curl \
        doxygen \
        g++ \
        git \
        gnupg \
        libcurl4-gnutls-dev \
        libfuzzy-dev \
        liblmdb-dev \
        liblua5.3-dev \
        libpcre2-dev \
        libtool \
        libxml2-dev \
        libyajl-dev \
        make \
        patch \
        pkg-config \
        ruby \
        zlib1g-dev; \
     apt-get clean; \
     rm -rf /var/lib/apt/lists/*

WORKDIR /sources

RUN set -eux; \
    git clone https://github.com/owasp-modsecurity/ModSecurity.git --branch "${MODSECURITY_VERSION}" --depth 1 --recursive; \
    cd ModSecurity; \
    ARCH=$(gcc -print-multiarch); \
    sed -ie "s/i386-linux-gnu/${ARCH}/g" build/ssdeep.m4; \
    sed -ie "s/i386-linux-gnu/${ARCH}/g" build/pcre2.m4; \
    ./build.sh; \
    ./configure --with-yajl --with-ssdeep --with-lmdb --with-pcre2 --enable-silent-rules; \
    make -j$(nproc) install; \
    strip /usr/local/modsecurity/lib/lib*.so*

RUN set -eux; \
    NGINX_VERSION=$(nginx -v 2>&1 | sed -E 's#.*nginx/([0-9.]+).*#\1#'); \
    git clone https://github.com/owasp-modsecurity/ModSecurity-nginx.git --branch "${MODSECURITY_NGINX_VERSION}" --depth 1; \
    curl -sSL "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx-${NGINX_VERSION}.tar.gz; \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz; \
    cd ./nginx-${NGINX_VERSION}; \
    ./configure --with-compat --add-dynamic-module=/sources/ModSecurity-nginx; \
    make -j$(nproc) modules; \
    strip objs/*.so; \
    cp objs/*.so /etc/nginx/modules/; \
    mkdir /etc/modsecurity.d; \
    curl -sSL https://raw.githubusercontent.com/owasp-modsecurity/ModSecurity/v3/master/unicode.mapping \
         -o /etc/modsecurity.d/unicode.mapping

FROM nginx:1.29.5 AS crs-downloader

ARG CRS_RELEASE="4.20.0"

USER root

RUN set -eux; \
    apt-get update; \
    apt-get -y install --no-install-recommends \
      ca-certificates \
      curl \
      gnupg; \
    mkdir -p /etc/modsecurity.d/owasp-crs; \
    chown nginx:nginx /etc/modsecurity.d/owasp-crs

USER nginx
WORKDIR /sources

RUN curl -sSL https://github.com/coreruleset/coreruleset/releases/download/v${CRS_RELEASE}/coreruleset-${CRS_RELEASE}-minimal.tar.gz -o v${CRS_RELEASE}-minimal.tar.gz; \
    curl -sSL https://github.com/coreruleset/coreruleset/releases/download/v${CRS_RELEASE}/coreruleset-${CRS_RELEASE}-minimal.tar.gz.asc -o coreruleset-${CRS_RELEASE}-minimal.tar.gz.asc; \
    gpg --fetch-key https://coreruleset.org/security.asc; \
    gpg --verify coreruleset-${CRS_RELEASE}-minimal.tar.gz.asc v${CRS_RELEASE}-minimal.tar.gz; \
    tar -zxf v${CRS_RELEASE}-minimal.tar.gz --strip-components=1 -C /etc/modsecurity.d/owasp-crs; \
    rm -f v${CRS_RELEASE}-minimal.tar.gz coreruleset-${CRS_RELEASE}-minimal.tar.gz.asc; \
    mv -v /etc/modsecurity.d/owasp-crs/crs-setup.conf.example /etc/modsecurity.d/owasp-crs/crs-setup.conf

FROM nginx:1.29.5 AS nginx
ENV TZ="Europe/Berlin"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN --mount=type=bind,target=/tmp/packages/,source=/tmp/packages/,from=builder \
    apt-get update \
    && . /tmp/packages/modules.env \
    && for module in $BUILT_MODULES; do \
           apt-get install --no-install-suggests --no-install-recommends -y /tmp/packages/nginx-module-${module}_${NGINX_VERSION}*.deb; \
       done \
    && rm -rf /var/lib/apt/lists/

RUN curl -L https://github.com/a8m/envsubst/releases/download/v1.4.2/envsubst-Linux-x86_64 -o /usr/local/bin/envsubst && chmod +x /usr/local/bin/envsubst

COPY etc /etc/
COPY docker-entrypoint.d /docker-entrypoint.d

RUN apt-get update && apt-get install -y \
      libcurl4-gnutls-dev \
      libfuzzy-dev \
      liblmdb-dev \
      liblua5.3-dev \
      libyajl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=modsecurity-builder /usr/local/modsecurity/lib/ /usr/local/modsecurity/lib/
COPY --from=modsecurity-builder /etc/nginx/modules/ngx_http_modsecurity_module.so /etc/nginx/modules/
COPY --from=modsecurity-builder /etc/modsecurity.d/unicode.mapping /etc/modsecurity.d/unicode.mapping
COPY --from=crs-downloader /etc/modsecurity.d/owasp-crs/ /etc/modsecurity.d/owasp-crs/

# Test nginx config
RUN nginx -t
VOLUME /var/cache/nginx

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail http://127.0.0.1:90/health || exit 1

FROM nginx AS styleguide

COPY styleguide /etc/nginx
