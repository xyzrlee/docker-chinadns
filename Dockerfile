#
# Dockerfile for ChinaDNS
#

FROM alpine AS builder

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
 # Build & install
 && git clone https://github.com/shadowsocks/ChinaDNS.git /tmp/repo/ChinaDNS \
 && cd /tmp/repo/ChinaDNS \
 && ./autogen.sh \
 && ./configure \
 && make install

# ------------------------------------------------

FROM alpine

COPY --from=builder /usr/local/bin/chinadns /usr/local/bin/chinadns

ENTRYPOINT ["chinadns"]
