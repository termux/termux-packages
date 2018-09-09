TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

## Version is DB modification date. Use script 'check-last-modified.sh'
## to view last modification date.
TERMUX_PKG_VERSION=20180906

_TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
                    'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
                    'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

_TERMUX_PKG_FILE=('GeoLite2-City.tar.gz'
                  'GeoLite2-Country.tar.gz'
                  'GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
_TERMUX_PKG_SHA256=('c68df20de81f738f047d2ff235c51bae09fc0e83e856aa4a4729b482dd420c5c'
                    'e5acb422d3a09c3ccbd55b98a0bf926e402dd9cd086d9b70f5d5f7524a8f3676'
                    '6e6fb278dc0bc04937d45f7730f921828d6d796ed81501955eee9024a6deb3e5')

termux_step_make_install() {
    for i in {0..2}; do
        termux_download "${_TERMUX_PKG_SRCURL[i]}" "${_TERMUX_PKG_FILE[i]}" "${_TERMUX_PKG_SHA256[i]}"
    done

    for _db in GeoLite2-{City,Country,ASN}; do
        tar --strip-components=1 -xf $_db.tar.gz --wildcards "*/$_db.mmdb"
    done

    install -d "${TERMUX_PREFIX}/share/GeoIP"
    install -m644 -t "${TERMUX_PREFIX}/share/GeoIP" GeoLite2-{City,Country,ASN}.mmdb
}
