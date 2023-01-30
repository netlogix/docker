#!/bin/bash

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PWD}:/serverspec ${1:-serverspec:latest} "spec/${2}"