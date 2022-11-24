TERMUX_PKG_HOMEPAGE=http://www.catb.org/~esr/open-adventure/
TERMUX_PKG_DESCRIPTION="Forward-port of the original Colossal Cave Adventure from 1976-77"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.11
TERMUX_PKG_SHA256=2dae27a5e59598da20d1bc49dbb50907d4d05ff9bc0ef2efecc6fccd1231378c
TERMUX_PKG_SRCURL=https://gitlab.com/esr/open-adventure/-/archive/${TERMUX_PKG_VERSION}/open-adventure-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libedit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_make_install () {
	install -m 0755 advent $TERMUX_PREFIX/bin
}
