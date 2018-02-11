ARG VERSION=xenial
FROM ubuntu:${VERSION}

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm THREADS=4
COPY entrypoint.sh /entrypoint
COPY less_termcap /etc/less_termcap

RUN apt-get update && apt-get install -y less man manpages-dev lsb-release && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY scripts/ /opt
RUN /opt/download_manuals.sh

ENTRYPOINT ["/entrypoint"]
CMD ["man"]
