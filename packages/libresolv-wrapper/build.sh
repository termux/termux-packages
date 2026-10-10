TERMUX_PKG_HOMEPAGE=https://cwrap.org/resolv_wrapper.html
TERMUX_PKG_DESCRIPTION="A wrapper for DNS name resolving or DNS faking"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.8
TERMUX_PKG_SRCURL=https://ftp.samba.org/pub/cwrap/resolv_wrapper-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fbc30f77da3e12ecd4ef66ccf5ab77e0b744930ccd89062404082f928a8ec2e0
TERMUX_PKG_DEPENDS="resolv-conf"

termux_step_pre_configure() {
	CFLAGS+=" -DANDROID_CHANGES -DLIBC_SO=\\\"libc.so\\\""
}
