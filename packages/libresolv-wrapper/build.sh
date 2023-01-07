TERMUX_PKG_HOMEPAGE=https://cwrap.org/resolv_wrapper.html
TERMUX_PKG_DESCRIPTION="A wrapper for DNS name resolving or DNS faking"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.7
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://ftp.samba.org/pub/cwrap/resolv_wrapper-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=460ae7fd5e53485be7dd99a55c5922f1cb1636b9e8821981d49ad16507c8a074
TERMUX_PKG_DEPENDS="resolv-conf"

termux_step_pre_configure() {
	CFLAGS+=" -DANDROID_CHANGES -DLIBC_SO=\\\"libc.so\\\""
}
