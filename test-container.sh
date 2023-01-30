#!/bin/bash

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    -v $(pwd):/serverspec serverspec:latest spec/