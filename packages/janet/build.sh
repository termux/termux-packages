TERMUX_PKG_HOMEPAGE=https://janet-lang.org
TERMUX_PKG_DESCRIPTION="Janet is a dialect of Lisp intended for embedding into programs and such"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION=1.36.0
TERMUX_PKG_SRCURL=https://github.com/janet-lang/janet/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=104aa500d4a43c2c147851823fd8b7cd06a90d01efcdff71529ff1fa68953bb4
TERMUX_PKG_DEPENDS="libandroid-spawn"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	--prefix=${TERMUX_PREFIX}
	-Db_lto=true
	-Depoll=true
	-Dos_name=android
"
