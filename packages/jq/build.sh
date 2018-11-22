TERMUX_PKG_HOMEPAGE=http://stedolan.github.io/jq/
TERMUX_PKG_DESCRIPTION="Command-line JSON processor"
TERMUX_PKG_VERSION=1.6
TERMUX_PKG_SHA256=5de8c8e29aaa3fb9cc6b47bb27299f271354ebb72514e3accadc7d38b5bbaa72
TERMUX_PKG_SRCURL=https://github.com/stedolan/jq/releases/download/jq-$TERMUX_PKG_VERSION/jq-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-oniguruma=no"
TERMUX_PKG_BUILD_IN_SRC=yes
