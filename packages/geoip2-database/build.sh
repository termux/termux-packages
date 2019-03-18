TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_VERSION=20190318

TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
TERMUX_PKG_SHA256=('a53cd802162df70d43277b0514c711ba6fc9df081ca79389628b4edf88ac6fc7'
				   'e4fec4b88e7bee9219c5b3fe9580a193862e3e2addd55a56a8427d0d585d3e65'
				   'dfb0d18db0f04765bc7738d3ccc342e7ba6baba775de48a716aa7cf42596608c')

termux_step_make_install() {
	install -Dm600 \
		-t "$TERMUX_PREFIX"/share/GeoIP/ \
		$(find "$TERMUX_PKG_SRCDIR" -type f -iname \*.mmdb)
}
