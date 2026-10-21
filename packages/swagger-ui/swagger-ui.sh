#!/usr/bin/env sh

# Serves Swagger UI for an OpenAPI definition (local file or URL).
usage() {
	echo "Usage: swagger-ui [-H host] [-p port] [file|url]" >&2
	exit 1
}

host=127.0.0.1
port=8080
while getopts H:p: opt; do
	case $opt in
		H) host=$OPTARG ;;
		p) port=$OPTARG ;;
		*) usage ;;
	esac
done
shift $((OPTIND - 1))

share="@TERMUX_PREFIX@/share/swagger-ui"
spec=${1:-https://petstore.swagger.io/v2/swagger.json}

root=$(mktemp -d) || exit 1
trap 'rm -rf "$root"' EXIT INT TERM
ln -s "$share"/* "$root"/

if [ -f "$spec" ]; then
	ln -s "$(realpath "$spec")" "$root/spec-$(basename "$spec")"
	spec=spec-$(basename "$spec")
fi

url=$(printf '%s' "$spec" | sed 's/[&|\\]/\\&/g')
rm "$root/swagger-initializer.js"
sed "s|https://petstore.swagger.io/v2/swagger.json|$url|" \
	"$share/swagger-initializer.js" > "$root/swagger-initializer.js"

echo "Swagger UI: http://$host:$port/"
python3 -m http.server --bind "$host" --directory "$root" "$port"
