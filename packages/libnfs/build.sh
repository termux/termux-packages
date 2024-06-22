TERMUX_PKG_HOMEPAGE=https://github.com/sahlberg/libnfs
TERMUX_PKG_DESCRIPTION="NFS client library"
TERMUX_PKG_LICENSE="LGPL-2.1, BSD 2-Clause, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENCE-LGPL-2.1.txt, LICENCE-BSD.txt, LICENCE-GPL-3.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.3"
TERMUX_PKG_SRCURL=https://github.com/sahlberg/libnfs/archive/libnfs-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d945cb4f4c8f82ee1f3640893a168810f794a28e1010bb007ec5add345e9df3e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_BREAKS="libnfs-dev"
TERMUX_PKG_REPLACES="libnfs-dev"

termux_step_pre_configure() {
	autoreconf -fi
}
