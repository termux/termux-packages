TERMUX_PKG_HOMEPAGE=http://www.catb.org/~esr/open-adventure/
TERMUX_PKG_DESCRIPTION="Forward-port of the original Colossal Cave Adventure from 1976-77 which was the origin of all later text adventures, dungeon-crawl (computer) games, and computer-hosted roleplaying games"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=5dd0df7a7caebf78e7450535109b70e834fff2e4b1252284d69ec7ce36583409
TERMUX_PKG_SRCURL=https://gitlab.com/esr/open-adventure/-/archive/${TERMUX_PKG_VERSION}/open-adventure-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libedit"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install () {
	install -m 0755 advent $TERMUX_PREFIX/bin
}
