TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
# Note: Strange download url:
TERMUX_PKG_VERSION=2.6.0b
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=d85c18398fd273e85c9f259e7aa9050aa51f190036815bafb832de779f8a03a7
# TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v${TERMUX_PKG_VERSION}/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v2.6.0a/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, libmpfr, libxml2, readline, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"
