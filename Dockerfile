FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm
COPY entrypoint.sh /entrypoint
COPY less_termcap /etc/less_termcap

RUN apt-get update && apt-get install -y less man manpages-dev

COPY scripts/ /opt
RUN /opt/download_manuals.sh

ENTRYPOINT ["/entrypoint"]
CMD ["man"]
