TERMUX_PKG_HOMEPAGE=https://github.com/dgoulet/torsocks
TERMUX_PKG_DESCRIPTION="Wrapper to safely torify applications"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL=https://github.com/dgoulet/torsocks/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="tor"
TERMUX_PKG_FOLDERNAME=torsocks-$TERMUX_PKG_VERSION

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}

