#https://hub.docker.com/_/caddy
FROM caddy:builder AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-webdav \
    --with github.com/caddy-dns/dnspod \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/format-encoder \
    --with github.com/mastercactapus/caddy2-proxyprotocol

FROM caddy

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY ./entrypoint.sh /entrypoint.sh

RUN apk add --no-cache libcap tzdata \
	&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && mkdir -p /usr/share/zoneinfo/Asia/ \
    && ln -s /etc/localtime /usr/share/zoneinfo/Asia/Shanghai \
    && setcap 'cap_net_bind_service=+ep' /usr/bin/caddy \
    && apk del libcap

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
