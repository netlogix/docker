#!/bin/bash

if [ ! -f "${1}" ]; then
  echo "Dockerfile does not exist" >&2
  exit 1
fi

if [[ -z "${2}" ]]; then
  VERSION=$(grep -Eo -m 1 '[0-9]+\.[0-9]+' ${1})
else
  VERSION="${2}"
fi

echo $VERSION
