TERMUX_PKG_HOMEPAGE=http://rig.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A program that generates fake identities"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.11
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/rig/rig/rig-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=00bfc970d5c038c1e68bc356c6aa6f9a12995914b7d4fda69897622cb5b77ab8
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin rig
	install -Dm600 -t $TERMUX_PREFIX/share/man/man6 rig.6
	install -Dm600 -t $TERMUX_PREFIX/share/rig data/*.idx
}
