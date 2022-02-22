TERMUX_PKG_HOMEPAGE=https://xiph.org/flac/
TERMUX_PKG_DESCRIPTION="FLAC (Free Lossless Audio Codec) library"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="COPYING.GPL, COPYING.LGPL, COPYING.Xiph"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_SRCURL=https://github.com/xiph/flac/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=53e9dbe3ae54a9f42c1e65afe7f516c02d8393c0c6d56bc455c15e1e044069a9
TERMUX_PKG_DEPENDS="libc++, libogg"
TERMUX_PKG_BREAKS="libflac-dev"
TERMUX_PKG_REPLACES="libflac-dev"

termux_step_pre_configure() {
	./autogen.sh
}
