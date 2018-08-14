TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=2.6.2
TERMUX_PKG_SHA256=bb52944426646a369a3b113d79f19bb92c7569bb3801f65f4fd416bed67e98d7
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v$TERMUX_PKG_VERSION/libqalculate-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libcurl, libmpfr, libxml2, readline, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"
