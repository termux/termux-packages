#!/bin/bash -e
## This script was obtained from https://git.archlinux.org/svntogit/community.git/tree/trunk?h=packages/geoip2-database

# Unicode characters taken from pactree.c
UNICODE_IS_FUN="\u2514\u2500"

verbose=0
if [[ $1 == -v ]]; then
    verbose=1
fi

URLS=(http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
      http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz
      http://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz)

for url in ${URLS[@]}; do
    last_mod=$(curl -sI $url | grep -i ^Last-Modified: | cut -d' ' -f2- | tr -d '\r')
    echo "$last_mod (${url##*/})"

    if ((verbose)); then
        build_id=$(curl -s $url | gzip -cd | grep -aoE '[0-9]{8} Build [0-9]*')
        echo -e "${UNICODE_IS_FUN}$build_id"
    fi
done

