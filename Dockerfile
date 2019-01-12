#
# Dockerfile for ChinaDNS
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

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
 && git clone https://github.com/xyzrlee/ChinaDNS.git /tmp/repo/ChinaDNS \
 && cd /tmp/repo/ChinaDNS \
 && ./autogen.sh \
 && ./configure \
 && make install \
 && rm -rf /tmp/repo/ChinaDNS \
 && curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' >/chnroute.txt \
 && apk del .build-deps

ENTRYPOINT ["chinadns", "-c", "/chnroute.txt"]
