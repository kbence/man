#!/usr/bin/env bash

function main() {
    local packages=$(list_packages)
    local count=$(echo "$packages" | wc -l)

    echo "$packages" | xargs -IPACKAGE -n1 -P4 /opt/download_manual_for_package.sh PACKAGE | \
        prepend_percentage $count

    rebuild_manual_db
}

function list_packages() {
    apt-cache dumpavail | awk '/^Package: / {print $2}'
}

function prepend_percentage() {
    local current=0

    while read line; do
        printf "[%3d%%] %s\n" $(($current * 100 / $count)) "$line"
        current=$(($current+1))
    done
}

function rebuild_manual_db() {
    mandb
}

main
