# syntax=docker/dockerfile:1
FROM debian:bullseye-slim AS chromium

RUN apt-get update && apt-get install -y \
    chromium \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r chromium && \
    useradd -r -g chromium chromium && \
    mkdir -p /home/chromium && \
    chown -R chromium:chromium /home/chromium

USER chromium

ENV REMOTE_DEBUGGING_PORT=9222 \
    ADDITIONAL_ARGS=''

CMD /usr/bin/chromium --headless --no-sandbox \
    --disable-gpu --disable-dev-shm-usage --remote-debugging-address=0.0.0.0 \
    --remote-debugging-port=${REMOTE_DEBUGGING_PORT} ${ADDITIONAL_ARGS}