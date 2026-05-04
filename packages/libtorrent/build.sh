TERMUX_PKG_HOMEPAGE=https://github.com/rakshasa/rtorrent/wiki
TERMUX_PKG_DESCRIPTION="Libtorrent BitTorrent library"
TERMUX_PKG_MAINTAINER="Krishna Kanhaiya @kcubeterm"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION="0.16.11"
TERMUX_PKG_SRCURL=https://github.com/rakshasa/libtorrent/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b1ccbc0f2241d840957d6e82cf1ea35fd537220d3f5478fef23994bd292bf184
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, libcurl, openssl, resolv-conf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-aligned=true
--without-fastcgi
"

termux_step_pre_configure() {
	autoreconf -fi

	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
