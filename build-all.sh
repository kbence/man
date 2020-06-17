#!/bin/bash -x

VERSIONS='xenial bionic focal'
LATEST_VERSION=$(echo "$VERSIONS" | awk '{print $NF}')

for version in $VERSIONS; do
    docker build -t kbence/man:$version --build-arg VERSION=$version . && \
        docker push kbence/man:$version && \

        if [[ $version == $LATEST_VERSION ]]; then
            docker tag kbence/man:$version kbence/man:latest && \
            docker push kbence/man:latest
        fi
done

docker push kbence/man:latest
