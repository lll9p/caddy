#!/usr/bin/env sh

set -ex

# 支持 host.docker.internal
echo -e "`/sbin/ip route | awk '/default/ { print $3 }'`\thost.docker.internal" | tee -a /etc/hosts > /dev/null

caddy run
