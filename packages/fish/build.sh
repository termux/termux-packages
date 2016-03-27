TERMUX_PKG_HOMEPAGE=http://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
_COMMIT=b1b2698a843b52ea18ae0f8fc1e5a2b6e003f409
TERMUX_PKG_VERSION=2.2.201603181154
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/archive/${_COMMIT}.zip
TERMUX_PKG_DEPENDS="ncurses, libgnustl, libandroid-support"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=fish-shell-$_COMMIT

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoconf

	CXXFLAGS+=" $CPPFLAGS"

	LDFLAGS+=" -lgnustl_shared"

	export PCRE2_CONFIG_EXTRAS="--host=$TERMUX_HOST_PLATFORM"
}
