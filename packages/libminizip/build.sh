TERMUX_PKG_HOMEPAGE=https://www.winimage.com/zLibDll/minizip.html
TERMUX_PKG_DESCRIPTION="Mini zip and unzip based on zlib"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="MiniZip64_info.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_SRCURL=https://github.com/madler/zlib/releases/download/v${TERMUX_PKG_VERSION}/zlib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d7a0654783a4da529d1bb793b7ad9c3318020af77667bcae35f95d0e42a792f3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/contrib/minizip"
	cd $TERMUX_PKG_SRCDIR
	autoreconf -fi
}
