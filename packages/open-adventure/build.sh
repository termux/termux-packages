TERMUX_PKG_HOMEPAGE=http://www.catb.org/~esr/open-adventure/
TERMUX_PKG_DESCRIPTION="Forward-port of the original Colossal Cave Adventure from 1976-77"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.13
TERMUX_PKG_SHA256=16ae2403753fe666fc9c80fb9312e267ab9bbd486dcd80942b7863624a2a0aab
TERMUX_PKG_SRCURL=https://gitlab.com/esr/open-adventure/-/archive/${TERMUX_PKG_VERSION}/open-adventure-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libedit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_make_install () {
	install -m 0755 advent $TERMUX_PREFIX/bin
}
