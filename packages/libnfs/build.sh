TERMUX_PKG_HOMEPAGE=https://github.com/sahlberg/libnfs
TERMUX_PKG_DESCRIPTION="NFS client library"
TERMUX_PKG_LICENSE="LGPL-2.1, BSD 2-Clause, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENCE-LGPL-2.1.txt, LICENCE-BSD.txt, LICENCE-GPL-3.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.2
TERMUX_PKG_SRCURL=https://github.com/sahlberg/libnfs/archive/libnfs-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=637e56643b19da9fba98f06847788c4dad308b723156a64748041035dcdf9bd3
TERMUX_PKG_BREAKS="libnfs-dev"
TERMUX_PKG_REPLACES="libnfs-dev"

termux_step_pre_configure() {
	autoreconf -fi
}
