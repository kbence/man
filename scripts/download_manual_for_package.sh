#!/usr/bin/env bash

function main() {
    download_manual_for_package "$1"
}

function download_manual_for_package() {
    local pkg=$1
    local tmpdir
    local msg=''

    (
        msg="man pages for '$pkg'."
        tmpdir=$(mktemp -d)
        chmod 777 "$tmpdir"
        cd "$tmpdir"

        apt-get download "$pkg" >/dev/null

        ar x *.deb 2>/dev/null
        tar xf data.tar.* 2>/dev/null

        if [[ -d usr/share/man ]]; then
            cp -rp usr/share/man/man* /usr/share/man
            msg="Installed $msg"
        else
            msg="Skipped $msg"
        fi

        rm -rf $tmpdir

        echo "$msg"
    )
}

main "$@"
