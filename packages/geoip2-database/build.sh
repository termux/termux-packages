TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_VERSION=20190426

TERMUX_PKG_SRCURL=('https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz'
				   'https://geolite.maxmind.com/download/geoip/database/GeoLite2-ASN.tar.gz')

## If these checksums becomes invalid - it's time to update package.
TERMUX_PKG_SHA256=('712fd689f7d5ebb27e7cec846138db7aa0e988e427a9eddd20e15db9796838bf'
				   '3b0978d7e2e7540350e773d3986db370af8fd5390c76df1ca777ab5cf202402c'
				   'a6a40e401a7b59b4a01c6a248cb722fb7f6d2840dfe0b32329a8fadbc9fb0fcb')

termux_step_make_install() {
	install -Dm600 \
		-t "$TERMUX_PREFIX"/share/GeoIP/ \
		$(find "$TERMUX_PKG_SRCDIR" -type f -iname \*.mmdb)
}
