FROM debian:bookworm-slim AS chromium-base

RUN apt-get update  \
    && apt-get install -y --no-install-recommends \
        ca-certificates  \
        curl \
    && echo "deb https://deb.debian.org/debian bookworm contrib non-free" >> /etc/apt/sources.list \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        chromium \
        fontconfig \
        fonts-freefont-ttf \
        fonts-gfs-neohellenic \
        fonts-indic \
        fonts-ipafont-gothic \
        fonts-kacst \
        fonts-liberation \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
        fonts-roboto \
        fonts-thai-tlwg \
        fonts-ubuntu \
        fonts-wqy-zenhei \
        nginx \
        ttf-mscorefonts-installer \
     && apt-get autoclean\
     && rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

FROM chromium-base AS chromium-patcher

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        brotli \
        git \
        python3 \
    && apt-get autoclean \
    && rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

RUN git clone https://chromium.googlesource.com/chromium/src/tools/grit /opt/tools/grit

RUN mkdir -p /tmp/chromium-pak/resources/ && \
    (cd /tmp/chromium-pak/resources/ && /opt/tools/grit/pak_util.py extract /usr/lib/chromium/resources.pak --brotli /usr/bin/brotli) && \
    sed -i 's|element\.textContent = options\[cssClass\]|element\.textContent = ((cssClass === "pageNumber") ? (parseInt(document\.querySelector("\.pageNumberOffset")?\.textContent ?? 0) + parseInt(options\[cssClass\])) : options\[cssClass\])|' $(grep -rwl '/tmp/chromium-pak/resources/' -e 'setupHeaderFooterTemplate') && \
    (cd /tmp/chromium-pak/resources/ && /opt/tools/grit/pak_util.py create /usr/lib/chromium/resources.pak)

FROM chromium-base AS chromium

RUN groupadd -r chromium && \
    useradd -r -g chromium chromium && \
    mkdir -p /home/chromium && \
    chown -R chromium:chromium /home/chromium

RUN mkdir -p /var/lib/nginx /run && \
    chown -R chromium:chromium /var/lib/nginx /run && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/sites-available/default
COPY index.html /var/lib/nginx/www/index.html

USER chromium

COPY --from=chromium-patcher /usr/lib/chromium/resources.pak /usr/lib/chromium/resources.pak

ENV ADDITIONAL_ARGS=''

CMD /usr/bin/chromium \
        --disable-dev-shm-usage \
        --disable-gpu \
        --headless \
        --no-sandbox \
        --remote-allow-origins=* \
        --remote-debugging-port=9221 \
        ${ADDITIONAL_ARGS} & \
    nginx -g "daemon off;"

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail http://127.0.0.1:9222/json/version || exit 1
