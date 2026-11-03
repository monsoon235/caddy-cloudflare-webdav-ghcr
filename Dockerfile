# syntax=docker/dockerfile:1

# Caddy with the Cloudflare DNS and WebDAV plugins, the same way as the "Adding custom Caddy modules"
# section of the official image: build with xcaddy, copy the binary over the one in the official image.
ARG CADDY_VERSION=2

# runs on the build host and cross compiles (CGO is off), so no emulation is needed for arm64
FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder AS builder
ARG CADDY_VERSION
ARG TARGETOS
ARG TARGETARCH
# x86-64 microarchitecture level (v1 to v4), ignored for other architectures
ARG GOAMD64=v1
ARG CLOUDFLARE_REF=latest
ARG WEBDAV_REF=latest
ENV CGO_ENABLED=0
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} GOAMD64=${GOAMD64} \
    xcaddy build v${CADDY_VERSION} \
        --with github.com/caddy-dns/cloudflare@${CLOUDFLARE_REF} \
        --with github.com/mholt/caddy-webdav@${WEBDAV_REF} \
        --output /usr/bin/caddy

FROM caddy:${CADDY_VERSION}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

LABEL org.opencontainers.image.source="https://github.com/monsoon235/caddy-cloudflare-webdav-ghcr" \
      org.opencontainers.image.description="Caddy with the caddy-dns/cloudflare and mholt/caddy-webdav plugins"
