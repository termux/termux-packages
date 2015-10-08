TERMUX_PKG_HOMEPAGE=http://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
TERMUX_PKG_VERSION=2.2.`date "+%Y%m%d%H%M"`
# TERMUX_PKG_SRCURL=http://fishshell.com/files/${TERMUX_PKG_VERSION}/fish-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/archive/master.zip
TERMUX_PKG_NO_SRC_CACHE=yes
TERMUX_PKG_DEPENDS="ncurses, libgnustl, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=fish-shell-master

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoconf

	CXXFLAGS+=" $CPPFLAGS"

	LDFLAGS+=" -lgnustl_shared"

	export PCRE2_CONFIG_EXTRAS="--host=$TERMUX_HOST_PLATFORM"
}
