#!/bin/bash

set -xeuo pipefail

VERSIONS='xenial bionic focal'
LATEST_VERSION=$(awk '{print $NF}' <<< "$VERSIONS")

PUSH=false


while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -p|--push) PUSH=true ;;
        --no-push) PUSH=false ;;
        -v|--version) VERSIONS="$2"; shift ;;
        *)
            echo "Unrecognized argument: '$1'" >&2
            exit 1
            ;;
    esac

    shift
done


for version in $VERSIONS; do
    if docker build -t kbence/man:$version --build-arg VERSION=$version .; then
        $PUSH && docker push kbence/man:$version
    fi

    if [[ $version == $LATEST_VERSION ]]; then
        if docker tag kbence/man:$version kbence/man:latest; then
            $PUSH && docker push kbence/man:latest
        fi
    fi
done
