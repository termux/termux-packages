TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="Library for reading information from media files"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="../../../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.05"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/MediaArea/MediaInfoLib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=98fa7516fc50772231575da0362bb03ab0bf050c90a8e2de75987127263154af
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcurl, libzen, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static --with-libcurl"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}"
	./autogen.sh
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
