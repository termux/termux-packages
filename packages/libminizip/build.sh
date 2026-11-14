TERMUX_PKG_HOMEPAGE=https://www.winimage.com/zLibDll/minizip.html
TERMUX_PKG_DESCRIPTION="Mini zip and unzip based on zlib"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="MiniZip64_info.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4"
TERMUX_PKG_SRCURL="https://github.com/madler/zlib/releases/download/v${TERMUX_PKG_VERSION}/zlib-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4f11c512053d7bab8d9e9b89bde3575add3e4c50a383b42ef6cb837035fc5a7c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/contrib/minizip"
	cd $TERMUX_PKG_SRCDIR && autoreconf -fi
}
