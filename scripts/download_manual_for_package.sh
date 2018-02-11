#!/usr/bin/env bash

function main() {
    download_manual_for_package "$@"
}

function download_manual_for_package() {
    local tmpdir
    local msg=''

    (
        tmpdir=$(mktemp -d)
        chmod 777 "$tmpdir"
        cd "$tmpdir"

        apt-get download "$@" >/dev/null

        if ls | grep .deb >/dev/null; then
            for f in *.deb; do
                ar x "$f" 2>/dev/null
                tar xf data.tar.* 2>/dev/null
                rm -f data.tar.*
            done

            cp -rp usr/share/man/man* /usr/share/man
        fi

        for pkg in "$@"; do
            echo "Finished installing man pages for $pkg"
        done

        cd - >/dev/null
        rm -rf $tmpdir
    )
}

main "$@"
