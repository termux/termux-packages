TERMUX_PKG_HOMEPAGE=https://github.com/dimkr/loksh
TERMUX_PKG_DESCRIPTION="A Linux port of OpenBSD's ksh"
TERMUX_PKG_VERSION=6.3
TERMUX_PKG_SHA256=4c8bccf3fef58dce1c67395cffbf4e95fb6ee597d582ff2d2b3a851b1e302b44
TERMUX_PKG_SRCURL=https://github.com/dimkr/loksh/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    CFLAGS+=" -D_PATH_DEFPATH=$TERMUX_PREFIX/bin:$TERMUX_PREFIX/bin/applets"
}
