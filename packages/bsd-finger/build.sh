TERMUX_PKG_HOMEPAGE=http://ftp.linux.org.uk/pub/linux/Networking/netkit/
TERMUX_PKG_DESCRIPTION="User information lookup program"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.17
TERMUX_PKG_SRCURL=http://ftp.linux.org.uk/pub/linux/Networking/netkit/bsd-finger-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=84885d668d117ef50e01c7034a45d8343d747cec6212e40e8d08151bc18e13fa
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	sed -n '1,/*\//p' finger/finger.c > LICENSE
}

termux_step_configure() {
	./configure
}
