TERMUX_PKG_HOMEPAGE=http://log4c.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A C library for flexible logging to files, syslog and other destinations"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.4
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/log4c/log4c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea
TERMUX_PKG_DEPENDS="libexpat"

termux_step_pre_configure() {
	autoreconf -fi
}
