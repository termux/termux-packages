TERMUX_PKG_HOMEPAGE=https://github.com/dgoulet/torsocks
TERMUX_PKG_DESCRIPTION="Wrapper to safely torify applications"
TERMUX_PKG_VERSION=2.2.0.2017.1.17
__TORSOCKS_REF=87b075dd16c675606adee792ef1e22691c51475b
TERMUX_PKG_SRCURL=https://github.com/dgoulet/torsocks/archive/${__TORSOCKS_REF}.tar.gz
TERMUX_PKG_DEPENDS="tor"
TERMUX_PKG_FOLDERNAME=torsocks-${__TORSOCKS_REF}

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}

