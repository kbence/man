ARG VERSION=xenial
FROM ubuntu:${VERSION} as ubuntu

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm THREADS=4
COPY entrypoint.sh /entrypoint
COPY less_termcap /etc/less_termcap

RUN apt-get update && apt-get install -y less man manpages-dev lsb-release && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY scripts/ /opt
RUN /opt/download_manuals.sh

FROM alpine:latest

COPY --from=ubuntu /usr/share/man /usr/share/man
COPY entrypoint.sh /entrypoint
COPY less_termcap /etc/less_termcap
RUN apk add bash gzip less man-db man-db-doc ncurses
RUN mandb

ENTRYPOINT ["/entrypoint"]
CMD ["man"]
