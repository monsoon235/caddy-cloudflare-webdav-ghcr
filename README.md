# caddy-cloudflare-webdav-ghcr

[Caddy](https://github.com/caddyserver/caddy) with the
[caddy-dns/cloudflare](https://github.com/caddy-dns/cloudflare) and
[mholt/caddy-webdav](https://github.com/mholt/caddy-webdav) plugins, built with `xcaddy` on top of the official
`caddy` image and published to `ghcr.io/monsoon235/caddy-cloudflare-webdav`.

A GitHub Actions workflow checks upstream every day (latest Caddy release and the head of the default branch of
both plugins) and builds a new image only when one of them changed.

## Tags

| Tag | What it is |
|---|---|
| `latest`, `<caddy version>` | multi-arch: `linux/amd64` (x86-64 v1, runs on every x86-64 CPU) and `linux/arm64` |
| `latest-amd64-v1`, `<caddy version>-amd64-v1` | x86-64, `GOAMD64=v1` |
| `latest-amd64-v2`, `<caddy version>-amd64-v2` | x86-64, `GOAMD64=v2` (SSE4.2, POPCNT, from about 2009) |
| `latest-amd64-v3`, `<caddy version>-amd64-v3` | x86-64, `GOAMD64=v3` (AVX2, BMI, from about 2015) |
| `latest-amd64-v4`, `<caddy version>-amd64-v4` | x86-64, `GOAMD64=v4` (AVX-512) |
| `latest-arm64`, `<caddy version>-arm64` | arm64 |
| `src-<key>` | marks the upstream state that has been built, used by the workflow, do not pull it |

The `v2` to `v4` builds are separate tags on purpose: a multi-arch tag can not choose a microarchitecture level
by itself, pick the one your CPU supports (`/lib64/ld-linux-x86-64.so.2 --help | grep supported`).

```bash
docker pull ghcr.io/monsoon235/caddy-cloudflare-webdav:latest
docker pull ghcr.io/monsoon235/caddy-cloudflare-webdav:latest-amd64-v3
```

## Notes

- The image is the official `caddy:<version>` image with `/usr/bin/caddy` replaced, so config, volumes and the
  entrypoint are the same. Like in the official image the binary has the file capability `cap_net_bind_service`,
  with `cap_drop: ALL` the container only starts if `NET_BIND_SERVICE` is added back.
- The binaries are built with `CGO_ENABLED=0` and cross compiled, no emulation is used for arm64.
- GitHub disables scheduled workflows of a repository without activity for 60 days, run the workflow once by hand
  (Actions, build, Run workflow) to enable it again.
- To rebuild without an upstream change use Run workflow with `force`.
