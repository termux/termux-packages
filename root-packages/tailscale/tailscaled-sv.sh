#!@TERMUX_PREFIX@/bin/sh
# This `tailscaled` service is adapted from:
# https://github.com/void-linux/void-packages/blob/d833c349beda6e8a00f84cec7c4e447b226c4eee/srcpkgs/tailscale/files/tailscaled/run
[ -r "$PREFIX/etc/default/tailscaled" ] && . "$PREFIX/etc/default/tailscaled"

exec 2>&1
exec tailscaled \
--state="$PREFIX/var/lib/tailscale/tailscaled.state" \
--socket="$PREFIX/var/run/tailscale/tailscaled.sock" \
--port "${PORT:-41641}" \
"${FLAGS}"
