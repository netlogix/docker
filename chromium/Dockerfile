FROM debian:bookworm-slim AS chromium

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
        socat \
        ttf-mscorefonts-installer \
     && apt-get autoclean\
     && rm -rf \
        /config/.cache \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

RUN groupadd -r chromium && \
    useradd -r -g chromium chromium && \
    mkdir -p /home/chromium && \
    chown -R chromium:chromium /home/chromium

USER chromium

ENV REMOTE_DEBUGGING_PORT=9222 \
    ADDITIONAL_ARGS=''

CMD /usr/bin/chromium \
        --disable-dev-shm-usage \
        --disable-gpu \
        --headless \
        --no-sandbox \
        --remote-allow-origins=http://127.0.0.1 \
        --remote-debugging-port=9221 \
        ${ADDITIONAL_ARGS} & \
    socat TCP-LISTEN:${REMOTE_DEBUGGING_PORT},fork,reuseaddr TCP:127.0.0.1:9221

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail --header "Host: 127.0.0.1" http://127.0.0.1:${REMOTE_DEBUGGING_PORT}/json/version || exit 1