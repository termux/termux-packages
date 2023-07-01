TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Library for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=23.06
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/libmediainfo/${TERMUX_PKG_VERSION}/libmediainfo_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cea1e5b2d1434389e2d12ad66fabfa0b25b471ef709af891787c7ddf3fe4b9b5
TERMUX_PKG_DEPENDS="libc++, libcurl, libzen, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static --with-libcurl"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
