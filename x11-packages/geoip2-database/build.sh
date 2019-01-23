TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

## Version is DB modification date. Use script 'check-last-modified.sh'
## to view last modification date.
TERMUX_PKG_VERSION=20190122

_TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
                    'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
                    'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

_TERMUX_PKG_FILE=('GeoLite2-City.tar.gz'
                  'GeoLite2-Country.tar.gz'
                  'GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
_TERMUX_PKG_SHA256=('589b8603a6cd98cf134f96de24618ba1d986a954e40409a67f398eb1edbf6084'
                    '1b627bd7a575500cbf9e675630ab2c9b1632c3727f3eab29a06e50568341bdfa'
                    '6fc0855cdc3514c5b7cf19fe1a2681c5b1bbc5009c3a89b1453b64c8c235ba2a')

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
