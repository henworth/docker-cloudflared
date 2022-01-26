ARG GOLANG_VERSION=1.17.2
ARG ALPINE_VERSION=3.14
ARG UPSTREAM_RELEASE_TAG=2022.1.2

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} as gobuild
ARG GOLANG_VERSION
ARG ALPINE_VERSION
ARG UPSTREAM_RELEASE_TAG

WORKDIR /tmp

RUN apk add --no-cache gcc build-base curl tar && \
    mkdir release && \
    curl -L "https://github.com/cloudflare/cloudflared/archive/refs/tags/${UPSTREAM_RELEASE_TAG}.tar.gz" | tar xvz --strip 1 -C ./release

WORKDIR /tmp/release/cmd/cloudflared

RUN go build ./

FROM alpine:${ALPINE_VERSION}

ARG GOLANG_VERSION
ARG ALPINE_VERSION

RUN adduser -S cloudflared; \
    apk add --no-cache ca-certificates bind-tools tzdata python3 python3-pip python3-setuptools; \
    rm -rf /var/cache/apk/*;

COPY --from=gobuild /tmp/release/cmd/cloudflared/cloudflared /usr/local/bin/cloudflared

RUN setcap CAP_NET_BIND_SERVICE+eip /usr/local/bin/cloudflared

# HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD nslookup -po=${PORT} cloudflare.com 127.0.0.1 || exit 1

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

USER cloudflared

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
