TERMUX_PKG_HOMEPAGE=https://github.com/williamh/dotconf
TERMUX_PKG_DESCRIPTION="dot.conf configuration file parser"
TERMUX_PKG_VERSION="1.4.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/williamh/dotconf/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5922c46cacf99b2ecc4853d28a2bda4a489292e73276e604bd9cba29dfca892d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure () {
	aclocal && libtoolize --force && autoreconf -fi
}
