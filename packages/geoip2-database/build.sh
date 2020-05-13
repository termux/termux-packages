TERMUX_PKG_HOMEPAGE=https://dev.maxmind.com/geoip/geoip2/geolite2/
TERMUX_PKG_DESCRIPTION="GeoLite2 IP geolocation databases compiled by MaxMind"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

# MaxMind removed databases from public access:
# https://blog.maxmind.com/2019/12/18/significant-changes-to-accessing-and-using-geolite2-databases/
# Reusing files from the our last build (2019.12.21).
TERMUX_PKG_VERSION=20191221
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dl.bintray.com/xeffyr/sources/geoip2-database/geolite2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7afd73d90325d4a8aa3707c0c4a34f89a4b469fe43b4f3a3d69da23884af1e70

termux_step_make_install() {
	install -Dm600 \
		-t "$TERMUX_PREFIX"/share/GeoIP/ \
		"${TERMUX_PKG_SRCDIR}"/GeoLite2-{ASN,Country,City}.mmdb
}
