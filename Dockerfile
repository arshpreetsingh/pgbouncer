# need to do impementation like this:
https://github.com/brainsam/pgbouncer/blob/master/Dockerfile

use Docke file from this:
https://github.com/ganehag/docker-pgbouncer/blob/master/Dockerfile
FROM alpine:3.5 as build_stage


RUN apk --update --no-cache --virtual build-dependencies add \
  autoconf \
  autoconf-doc \
  automake \
  c-ares \
  c-ares-dev \
  curl \
  gcc \
  libc-dev \
  libevent \
  libevent-dev \
  libtool \
  make \
  man \
  openssl-dev \
  pkgconfig \
  && \
  \
  \
  apk --no-cache add libevent c-ares libssl1.0 libcrypto1.0 && \
  \
  \
  echo "=======> download source" && \
  curl -o  /tmp/pgbouncer-1.7.2.tar.gz -L https://pgbouncer.github.io/downloads/files/1.7.2/pgbouncer-1.7.2.tar.gz && \
  cd /tmp && \
  tar xvfz /tmp/pgbouncer-1.7.2.tar.gz && \
  mv pgbouncer-1.7.2 pgbouncer && \
  cd pgbouncer && \
  ./configure --prefix=/usr && \
  make && \
  make install && \
  cd .. && \
  ls -R /pgbouncer

FROM alpine:latest
RUN apk --update add libevent openssl c-ares
WORKDIR /
COPY --from=build_stage /pgbouncer /pgbouncer
ADD entrypoint.sh ./
ENTRYPOINT ["./entrypoint.sh"]
