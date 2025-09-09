TERMUX_PKG_HOMEPAGE=https://djvu.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Suite to create, manipulate and view DjVu ('déjà vu') documents"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.5.29"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/djvu/djvulibre-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3b4b03ae2bdca8516a36ef6eb27b777f0528c9eda26745d9962824a3fdfeccf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libjpeg-turbo, libtiff"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh

	# ERROR: ./lib/libdjvulibre.so contains undefined symbols: __aeabi_idiv
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
