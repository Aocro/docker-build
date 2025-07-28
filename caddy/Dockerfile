FROM caddy:builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/acmedns \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/greenpau/caddy-security

FROM caddy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
