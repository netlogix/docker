# syntax=docker/dockerfile:1
FROM httpd:2.4-alpine AS base
ENV FPM_BACKEND=php-fpm:9000
COPY config/defaults /usr/local/apache2/
RUN sed -i 's/LoadModule autoindex_module/#LoadModule autoindex_module/g' /usr/local/apache2/conf/httpd.conf
RUN echo "Include conf/http_custom.conf" >> /usr/local/apache2/conf/httpd.conf

# Port for prometheus exporter
EXPOSE 90

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD wget -qO- http://localhost:90/health | grep -q 'health'

FROM base AS httpd-typo3
COPY config/typo3 /usr/local/apache2/vhosts

FROM base AS httpd-neos
COPY config/neos /usr/local/apache2/vhosts

FROM base AS httpd-shopware
COPY config/shopware /usr/local/apache2/vhosts

FROM base AS httpd-shopware6
COPY config/shopware6 /usr/local/apache2/vhosts

FROM base AS httpd-symfony
COPY config/symfony /usr/local/apache2/vhosts

FROM base AS httpd-static
COPY config/static /usr/local/apache2/vhosts
