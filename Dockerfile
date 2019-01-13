#
# Dockerfile for ChinaDNS
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

COPY ./chnroute.sh /

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      git \
      curl \
 # Build & install
 && git clone https://github.com/shadowsocks/ChinaDNS.git /tmp/repo/ChinaDNS \
 && cd /tmp/repo/ChinaDNS \
 && ./autogen.sh \
 && ./configure \
 && make install \
 && cd / \
 && rm -rf /tmp/repo \
 && sh /chnroute.sh >/chnroute.txt \
 && apk del .build-deps

ENTRYPOINT ["chinadns", "-c", "/chnroute.txt"]
