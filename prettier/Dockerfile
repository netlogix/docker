FROM node:24-alpine AS prettier

RUN apk add --no-cache bash

RUN addgroup prettier && \
    adduser -G prettier -s /bin/bash -D prettier

USER prettier

WORKDIR /home/prettier

COPY --chown=prettier:prettier . ./

RUN npm install

ENTRYPOINT ["/home/prettier/entrypoint.sh"]
