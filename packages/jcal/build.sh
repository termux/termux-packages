TERMUX_PKG_HOMEPAGE="http://nongnu.org/jcal"
TERMUX_PKG_DESCRIPTION="UNIX-cal-like tool to display Jalali (Persian/Iranian) calendar"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/persiancal/jcal/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6cc477c668962de9250b7aebfdf0eee979ab94ec4f393dc04782024ef68fff45
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cd sources
	./autogen.sh
	sed --in-place 's/$RM "$cfgfile"/$RM -f "$cfgfile"/g' configure
	TERMUX_PKG_SRCDIR+="/sources"
}

termux_step_post_configure() {
	# removing tests
	sed --in-place 's/test_kit//g' sources/Makefile.am
}
