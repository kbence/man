#!/usr/bin/env bash

function main() {
    local packages=$(list_packages)
    local count=$(echo "$packages" | wc -l)
    local current=0

    while read package; do
        printf "[%3d%%] " $(($current * 100 / $count))
        download_manual_for_package "$package"
        current=$(($current+1))
    done <<< "$packages"

    rebuild_manual_db
}

function list_packages() {
    apt-cache dumpavail | awk '/^Package: / {print $2}'
}

function download_manual_for_package() {
    local pkg=$1
    local tmpdir

    (
        echo -n "Installing man pages for '$pkg'... "
        tmpdir=$(mktemp -d)
        chmod 777 "$tmpdir"
        cd "$tmpdir"

        apt-get download "$pkg" >/dev/null
        echo -n 'downloaded '

        ar x *.deb
        tar xf data.tar.*
        echo -n 'extracted '

        if [[ -d usr/share/man ]]; then
            cp -rp usr/share/man/man* /usr/share/man
            echo -n 'copied'
        else
            echo -n 'skipped'
        fi

        rm -rf $tmpdir
        echo
    )
}

function rebuild_manual_db() {
    mandb
}

main
