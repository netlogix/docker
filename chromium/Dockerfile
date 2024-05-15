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
        fonts-freefont-ttf \
        fonts-indic \
        fonts-ipafont-gothic \
        fonts-kacst \
        fonts-liberation \
        fonts-noto-cjk \
        fonts-thai-tlwg \
        fonts-wqy-zenhei \
        ttf-mscorefonts-installer \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r chromium && \
    useradd -r -g chromium chromium && \
    mkdir -p /home/chromium && \
    chown -R chromium:chromium /home/chromium

USER chromium

ENV REMOTE_DEBUGGING_PORT=9222 \
    ADDITIONAL_ARGS=''

CMD /usr/bin/chromium --headless --no-sandbox \
    --disable-gpu --disable-dev-shm-usage --remote-debugging-address=0.0.0.0 --remote-allow-origins=http://127.0.0.1 \
    --remote-debugging-port=${REMOTE_DEBUGGING_PORT} ${ADDITIONAL_ARGS}

HEALTHCHECK --interval=2s --timeout=20s --retries=10 CMD curl --silent --fail --header "Host: 127.0.0.1" http://127.0.0.1:${REMOTE_DEBUGGING_PORT}/json/version || exit 1