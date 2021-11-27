TERMUX_PKG_HOMEPAGE=https://www.eblong.com/zarf/glulx/
TERMUX_PKG_DESCRIPTION="Interpreter for the Glulx portable VM for interactive fiction (IF) games"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(0.5.4
                    1.0.4)
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=(https://www.eblong.com/zarf/glulx/glulxe-${TERMUX_PKG_VERSION[0]//.}.tar.gz
                   https://www.eblong.com/zarf/glk/glktermw-${TERMUX_PKG_VERSION[1]//.}.tar.gz)
TERMUX_PKG_SHA256=(1fc26f8aa31c880dbc7c396ede196c5d2cdff9bdefc6b192f320a96c5ef3376e
                   5968630b45e2fd53de48424559e3579db0537c460f4dc2631f258e1c116eb4ea)
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="ncurses"

termux_step_post_configure () {
	CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" PREFIX=$TERMUX_PREFIX make -C glkterm
}

termux_step_make_install () {
	install glulxe $TERMUX_PREFIX/bin
}
