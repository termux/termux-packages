TERMUX_PKG_HOMEPAGE=https://github.com/williamh/dotconf
TERMUX_PKG_DESCRIPTION="dot.conf configuration file parser"
TERMUX_PKG_VERSION=1.3
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SHA256=7f1ecf40de1ad002a065a321582ed34f8c14242309c3547ad59710ae3c805653
TERMUX_PKG_SRCURL=https://github.com/williamh/dotconf/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_pre_configure () {
	aclocal && libtoolize --force && autoreconf -fi
}
