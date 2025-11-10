#!/bin/bash
docker run -it --rm \
  -e LOG_LEVEL=debug \
  -e RENOVATE_TOKEN=$(gh auth token) \
  -e GITHUB_COM_TOKEN=$(gh auth token) \
  -v "$(pwd)":/usr/src/app \
  -w /usr/src/app \
  ghcr.io/renovatebot/renovate \
  --platform=local --repository-cache=reset --dry-run