FROM ubuntu:xenial

RUN apt-get update && apt-get install -y less man manpages-dev

COPY entrypoint.sh /entrypoint
COPY less_termcap /etc/less_termcap

ENTRYPOINT ["/entrypoint"]
CMD ["man"]
