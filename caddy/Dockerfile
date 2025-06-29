FROM caddy:builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/acmedns \
    --with github.com/RussellLuo/caddy-ext/layer4 \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive

FROM caddy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
