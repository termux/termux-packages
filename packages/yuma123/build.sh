TERMUX_PKG_HOMEPAGE=https://yuma123.org/
TERMUX_PKG_DESCRIPTION="Provides an opensource YANG API in C"
TERMUX_PKG_LICENSE="BSD 3-Clause, MIT, Public Domain"
TERMUX_PKG_LICENSE_FILE="debian/copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.13
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/yuma123/yuma123_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e304b253236a279f10b133fdd19f366f271581ebf12647cea84667fcfada1f0c
TERMUX_PKG_DEPENDS="libssh2, libxml2, openssl, readline"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -D__USE_BSD"
}
