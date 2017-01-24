FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm
RUN apt-get update && apt-get install -y less man manpages-dev binutils xz-utils

COPY entrypoint.sh /entrypoint
COPY less_termcap /etc/less_termcap

COPY scripts/download_manuals.sh /opt/download_manuals.sh
RUN /opt/download_manuals.sh

ENTRYPOINT ["/entrypoint"]
CMD ["man"]
