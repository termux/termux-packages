#!/bin/sh
set -eu

pkg install -y wrangler curl

wrangler --version
wrangler2 --version
"$PREFIX/lib/wrangler/native/esbuild" --version
"$PREFIX/lib/wrangler/native/workerd" --version 2>&1 | grep -F workerd

smoke="${TMPDIR:-$PREFIX/tmp}/wrangler-package-smoke-$$"
rm -rf "$smoke"
mkdir -p "$smoke"
trap 'rm -rf "$smoke"' EXIT INT TERM
cd "$smoke"

cat > index.js <<'JS'
export default { fetch() { return new Response("termux-wrangler-ok"); } };
JS
cat > wrangler.jsonc <<'JSON'
{"name":"termux-wrangler-package-smoke","main":"index.js","compatibility_date":"2026-08-01"}
JSON

WRANGLER_SEND_METRICS=false wrangler deploy --dry-run --outdir "$smoke/dry-run"
WRANGLER_SEND_METRICS=false wrangler dev --ip 127.0.0.1 --port 8791 >"$smoke/dev.log" 2>&1 &
pid=$!
cleanup() {
	kill "$pid" 2>/dev/null || true
	wait "$pid" 2>/dev/null || true
	rm -rf "$smoke"
}
trap cleanup EXIT INT TERM

body=""
i=0
while [ "$i" -lt 120 ]; do
	if ! kill -0 "$pid" 2>/dev/null; then
		cat "$smoke/dev.log"
		exit 1
	fi
	if body="$(curl -fsS --max-time 3 http://127.0.0.1:8791/ 2>/dev/null)"; then
		break
	fi
	i=$((i + 1))
	sleep 1
done

[ "$body" = "termux-wrangler-ok" ] || {
	cat "$smoke/dev.log"
	exit 1
}
printf 'Wrangler local Worker smoke: %s\n' "$body"
