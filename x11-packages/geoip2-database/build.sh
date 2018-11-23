TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

## Version is DB modification date. Use script 'check-last-modified.sh'
## to view last modification date.
TERMUX_PKG_VERSION=20181121

_TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
                    'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
                    'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

_TERMUX_PKG_FILE=('GeoLite2-City.tar.gz'
                  'GeoLite2-Country.tar.gz'
                  'GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
_TERMUX_PKG_SHA256=('285df7f90959060fa3509a64a89ea5dbc556b5e4f1262e6e5504558d61bc132b'
                    '825b22518e8a229ed6a63bd2fac4e0d4f6d3fc2d782a903ca8de777e43d2138a'
                    '8b368619248223d29e41375a14c6172dc667d6bdd16ea5f647e91c3c4833877c')

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
