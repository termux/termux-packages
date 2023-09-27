TERMUX_PKG_HOMEPAGE=https://www.winimage.com/zLibDll/minizip.html
TERMUX_PKG_DESCRIPTION="Mini zip and unzip based on zlib"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="MiniZip64_info.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_SRCURL=https://www.zlib.net/zlib-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=8a9ba2898e1d0d774eca6ba5b4627a11e5588ba85c8851336eb38de4683050a7
TERMUX_PKG_DEPENDS="zlib"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/contrib/minizip"
	cd $TERMUX_PKG_SRCDIR
	autoreconf -fi
}
