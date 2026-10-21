#!/usr/bin/env sh

usage() {
	echo "Usage: swagger-editor [-H host] [-p port]" >&2
	exit 1
}

host=127.0.0.1
port=3050
while getopts H:p: opt; do
	case $opt in
		H) host=$OPTARG ;;
		p) port=$OPTARG ;;
		*) usage ;;
	esac
done

echo "Swagger Editor: http://$host:$port/"
exec python3 -m http.server --bind "$host" \
	--directory "@TERMUX_PREFIX@/share/swagger-editor" "$port"
