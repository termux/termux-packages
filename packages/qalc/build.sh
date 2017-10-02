TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v${TERMUX_PKG_VERSION}/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=86d04362f37aa5acbc78108e0044b96fbffbaa33c309c19c8c37ac4fb46c5485
TERMUX_PKG_DEPENDS="libcurl, libmpfr, libxml2, readline, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"
