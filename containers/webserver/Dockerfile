# syntax=docker/dockerfile:1
FROM httpd:2.4-alpine as base
ENV FPM_BACKEND=php-fpm:9000
COPY config/defaults /usr/local/apache2/
RUN sed -i 's/LoadModule autoindex_module/#LoadModule autoindex_module/g' /usr/local/apache2/conf/httpd.conf
RUN echo "Include conf/http_custom.conf" >> /usr/local/apache2/conf/httpd.conf

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD wget -qO- http://localhost:90/health | grep -q 'health'

FROM base AS webserver-typo3
COPY config/typo3 /usr/local/apache2/vhosts

FROM base AS webserver-neos
COPY config/neos /usr/local/apache2/vhosts

FROM base AS webserver-shopware
COPY config/shopware /usr/local/apache2/vhosts

FROM base AS webserver-static
COPY config/static /usr/local/apache2/vhosts
