TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_SHA256=7668ed9ab32d46d3638297985a03bc995b6aedf8b8335685e1a43393ba236f12
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v${TERMUX_PKG_VERSION}/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, libmpfr, libxml2, readline, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"
