TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_SHA256=1752b6a046eaf84ee62a7dc8d2c874b538517956ce8affac80df09a3b55bef5d
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v${TERMUX_PKG_VERSION}/libqalculate-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libcurl, libmpfr, libxml2, readline, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"
