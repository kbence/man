#!/usr/bin/env bash

set -e

function main() {
    local packages
    local count

    init
    packages=$(list_packages)
    count=$(echo "$packages" | wc -l)

    echo "$packages" | xargs -n20 -P${THREADS:-4} /opt/download_manual_for_package.sh | \
        prepend_progress $count

    cleanup
    rebuild_man_db
}

function use_old_releases() {
    sed -i 's/archive/old-releases/g' /etc/apt/sources.list
}

function for_lsb_codename() {
    local lsb_codename="$1"; shift

    echo "LSB_RELEASE: $(lsb_release -sc), LSB_CODENAME: $lsb_codename"

    if [[ $(lsb_release -sc) == $lsb_codename ]]; then
        "$@"
    fi
}

function init() {
    for_lsb_codename precise use_old_releases

    echo "Installing necessary utilities..."
    apt-get update
    apt-get install -y binutils xz-utils apt-file

    echo 'Updating apt-file DB...'
    apt-file update
}

function cleanup() {
    echo "Cleaning up apt-file DB..."
    rm -rf /var/cache/apt/apt-file/*

    echo "Purging caches..."
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
}

function list_packages() {
    apt-file search /man/ | cut -d: -f1 | sort | uniq
}

function prepend_progress() {
    local count=$1
    local current=0
    local start_time=$(date +%s)
    local current_time
    local time_remaining

    while read line; do
        current_time=$(date +%s)

        if [[ $current -ge 10 ]]; then
            time_remaining=$(( (($current_time - $start_time) * $count / $current - ($current_time - $start_time)) / 60 ))m
        else
            time_remaining='INF'
        fi

        printf "[%3d%%] [ETA: %s] %s\n" $(($current * 100 / $count)) $time_remaining "$line"
        current=$(($current+1))
    done
}

function rebuild_man_db() {
    mandb
}

main
