TERMUX_PKG_HOMEPAGE=https://www.monetdb.org/
TERMUX_PKG_DESCRIPTION="A high-performance database kernel for query-intensive applications"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=11.41.13
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.monetdb.org/downloads/sources/archive/MonetDB-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7738e106ac3a39bfb37feb8efa9a050a412fb332ab58c29a8aad23c01ba42197
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore, libbz2, libcurl, libiconv, liblz4, liblzma, libpcreposix, libuuid, libxml2, netcdf-c, openssl, readline, zlib"

termux_step_post_get_source() {
	find . -name '*.c' | xargs -n 1 sed -i \
		-e 's:"\(/tmp\):"'$TERMUX_PREFIX'\1:g'
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-sysv-semaphore"
}
