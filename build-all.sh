#!/bin/bash -x

VERSIONS='precise trusty xenial zesty'

for version in $VERSIONS; do
    docker build -t kbence/man:$version --build-arg VERSION=$version .
    docker push kbence/man:$version
    docker tag -t kbence/man:$version kbence/man:latest
done

docker push kbence/man:latest
