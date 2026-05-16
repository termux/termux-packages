TERMUX_PKG_HOMEPAGE=https://zsync.moria.org.uk/
TERMUX_PKG_DESCRIPTION="A file transfer program to download files from remote web servers"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.4"
TERMUX_PKG_SRCURL=https://zsync.moria.org.uk/download/zsync-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f1d6d3e8e79933e9e03dd9f342673f31274686a29d295e7cb34558755d224670
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Workaround compiler error due to older C syntax
	CFLAGS+=" -std=c11"
}
