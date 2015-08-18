TERMUX_PKG_HOMEPAGE=http://stedolan.github.io/jq/
TERMUX_PKG_DESCRIPTION="Command-line JSON processor"
TERMUX_PKG_VERSION=1.5
TERMUX_PKG_SRCURL=https://github.com/stedolan/jq/archive/jq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=jq-jq-${TERMUX_PKG_VERSION}

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoreconf -i
}
