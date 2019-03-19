TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_VERSION=20190320

TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
TERMUX_PKG_SHA256=('b3f844774b6a0423872b92c8ebab0990387c1e8fbf57122621963d6b357240c2'
				   'b173951d63301c1c5817985525f836d80bf5f21574cf3fe3bdaf84632e4cf423'
				   'dfb0d18db0f04765bc7738d3ccc342e7ba6baba775de48a716aa7cf42596608c')

termux_step_make_install() {
	install -Dm600 \
		-t "$TERMUX_PREFIX"/share/GeoIP/ \
		$(find "$TERMUX_PKG_SRCDIR" -type f -iname \*.mmdb)
}
