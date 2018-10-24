FROM isaackuang/alpine-base:3.8.0 as builder

MAINTAINER Isaac Tseng <isaac.kuang@gmail.com>

WORKDIR /tmp
RUN apk add -t build-depends build-base automake bzip2 patch git cmake openssl-dev libc6-compat libexecinfo-dev && \
    git clone https://github.com/sysown/proxysql.git && \
    cd proxysql && \
    git checkout v1.4.12 && \
    make clean && \
    make build_deps && \
    NOJEMALLOC=1 make

FROM isaackuang/alpine-base:3.8.0
MAINTAINER Isaac Tseng <isaac.kuang@gmail.com>
RUN apk add --no-cache -t runtime-depends libgcc libstdc++ libcrypto1.0 libssl1.0 && \
    mkdir -p /var/lib/proxysql

COPY --from=builder /tmp/proxysql/src/proxysql /usr/bin/proxysql

COPY config /
