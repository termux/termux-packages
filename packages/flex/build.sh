TERMUX_PKG_HOMEPAGE=http://flex.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Fast lexical analyser generator"
TERMUX_PKG_VERSION=2.6.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://heanet.dl.sourceforge.net/project/flex/flex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="m4"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="ac_cv_path_M4=$TERMUX_PREFIX/bin/m4"
