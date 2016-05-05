TERMUX_PKG_HOMEPAGE=http://fishshell.com/
TERMUX_PKG_DESCRIPTION="Shell geared towards interactive use"
_COMMIT=c76d86631717929b3a2f259615e8603e69e13256
TERMUX_PKG_VERSION=2.2.201605030720
TERMUX_PKG_SRCURL=https://github.com/fish-shell/fish-shell/archive/${_COMMIT}.zip
# fish calls 'tput' from ncurses-utils, at least when cancelling (Ctrl+C) a command line:
TERMUX_PKG_DEPENDS="ncurses, libgnustl, libandroid-support, ncurses-utils"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=fish-shell-$_COMMIT

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoconf

	CXXFLAGS+=" $CPPFLAGS"

	LDFLAGS+=" -lgnustl_shared"

	export PCRE2_CONFIG_EXTRAS="--host=$TERMUX_HOST_PLATFORM"
}
