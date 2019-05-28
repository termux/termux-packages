TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_VERSION=20190528

TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
TERMUX_PKG_SHA256=('84c1d9c6f4aca2fb2a125fb2eaf3afa7601b3e4f9a76081c72d71b52931e79ca'
				   'f5584976158d92627b4380c97ce0a0424198894a637752746cbed12c83d9c49d'
				   'c3a966865e5d814c2ca9fdf874e41c882a5d4a1132de1fc036776841d9922db7')

termux_step_make_install() {
	install -Dm600 \
		-t "$TERMUX_PREFIX"/share/GeoIP/ \
		$(find "$TERMUX_PKG_SRCDIR" -type f -iname \*.mmdb)
}
