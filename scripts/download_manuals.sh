#!/usr/bin/env bash

function main() {
    local packages
    local count

    init_utils
    packages=$(list_packages)
    count=$(echo "$packages" | wc -l)

    echo "$packages" | xargs -IPACKAGE -n1 -P12 /opt/download_manual_for_package.sh PACKAGE | \
        prepend_progress $count

    cleanup_utils
    rebuild_man_db
}

function init_utils() {
    echo "Installing necessary utilities..."
    apt-get install -y binutils xz-utils apt-file

    echo 'Updating apt-file DB...'
    apt-file update
}

function cleanup_utils() {
    echo "Cleaning up apt-file DB..."
    rm -rf /var/cache/apt/apt-file/*

    echo "Purging utilities..."
    apt-get purge -f --force-yes binutils xz-utils apt-file
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
