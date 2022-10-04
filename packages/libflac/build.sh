TERMUX_PKG_HOMEPAGE=https://xiph.org/flac/
TERMUX_PKG_DESCRIPTION="FLAC (Free Lossless Audio Codec) library"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING.GPL, COPYING.LGPL, COPYING.Xiph"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://downloads.xiph.org/releases/flac/flac-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=91303c3e5dfde52c3e94e75976c0ab3ee14ced278ab8f60033a3a12db9209ae6
TERMUX_PKG_DEPENDS="libc++, libogg"
TERMUX_PKG_BREAKS="libflac-dev"
TERMUX_PKG_REPLACES="libflac-dev"

termux_step_post_get_source() {
	# Aligned with configure.ac.patch.
	local f
	for f in doc/FLAC.tag doc/api/modules.html; do
		if ! test -r "${f}"; then
			termux_error_exit "File ${f} not readable."
		fi
	done
}

termux_step_pre_configure() {
	autoreconf -fi
}
