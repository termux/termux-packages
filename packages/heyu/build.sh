TERMUX_PKG_HOMEPAGE=https://www.heyu.org/
TERMUX_PKG_DESCRIPTION="Program for remotely controlling lights and appliances"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=2.11-rc3
TERMUX_PKG_SHA256=6285f134e03688b5ec03986ef53cce463abc007281996156cac52b61cbeb58b2
TERMUX_PKG_SRCURL=https://github.com/HeyuX10Automation/heyu/archive/v$TERMUX_PKG_VERSION.tar.gz

termux_step_pre_configure() {
	# rindex is an obsolete version of strrchr which is not available in Android:
	CFLAGS+=" -Drindex=strrchr"
	export LIBS="-llog"
}
