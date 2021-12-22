TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Library for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.09
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/libmediainfo/${TERMUX_PKG_VERSION}/libmediainfo_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9331e9bc04bfc1d46bb8615723715ceabdf936f90d478691ae2eabf6a26c1d40
TERMUX_PKG_DEPENDS="libcurl, libzen, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static --with-libcurl"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh
}

termux_step_post_make_install() {
	ln -sf "${TERMUX_PREFIX}/lib/libmediainfo.so" "${TERMUX_PREFIX}/lib/libmediainfo.so.0"
	ln -sf "${TERMUX_PREFIX}/lib/libmediainfo.so" "${TERMUX_PREFIX}/lib/libmediainfo.so.0.0"
}
