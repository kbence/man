# man

Simple scripts to create a Docker image for Ubuntu LTS versions which contain all the manual pages available (with default apt sources).

## Usage

The image is currently built for all the supported LTS versions of Ubuntu (+precise). The images are uploaded to Docker Hub and tagged with the LTS codename. To check out a man page, use the following command:

    docker run -it --rm -e TERM="$TERM" kbence/man:<lts_codename> <man_page>

where lts_codename can be `precise`, `trusty`, `xenial`, `bionic`.

To make it easier to use, there's a script called `lman` in the repository. This script will pass your `TERM` environment variable to optionally enable colorful output. It's usage is really simple:

    ./lman [--<lsb_codename>] [arg [arg ...]]
