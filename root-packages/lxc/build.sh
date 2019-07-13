TERMUX_PKG_HOMEPAGE=http://linuxcontainers.org/
TERMUX_PKG_DESCRIPTION="Linux Containers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://linuxcontainers.org/downloads/lxc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4d8772c25baeaea2c37a954902b88c05d1454c91c887cb6a0997258cfac3fdc5
TERMUX_PKG_DEPENDS="dirmngr, gnupg, libcap, rsync, wget"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-distro=termux
--with-runtime-path=$TERMUX_PREFIX/var/run
"

termux_step_pre_configure() {
	export LIBS="-llog"
}
