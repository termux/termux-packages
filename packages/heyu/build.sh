TERMUX_PKG_HOMEPAGE=http://www.heyu.org/
TERMUX_PKG_DESCRIPTION="A text-based console program for remotely controlling lights and appliances in the home or office"
TERMUX_PKG_VERSION=2.11-rc2
TERMUX_PKG_SRCURL=https://github.com/HeyuX10Automation/heyu/archive/v$TERMUX_PKG_VERSION.tar.gz

termux_step_pre_configure () {
	# rindex is an obsolete version of strrchr which is not available in Android:
	CFLAGS+=" -Drindex=strrchr"
	LDFLAGS+=" -llog"
}
