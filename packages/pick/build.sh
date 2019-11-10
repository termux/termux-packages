TERMUX_PKG_HOMEPAGE=https://github.com/calleerlandsson/pick
TERMUX_PKG_DESCRIPTION="Utility to choose one option from a set of choices with fuzzy search functionality"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SHA256=668c863751f94ad90e295cf861a80b4d94975e06645f401d7f82525e607c0266
TERMUX_PKG_SRCURL=https://github.com/calleerlandsson/pick/releases/download/v${TERMUX_PKG_VERSION}/pick-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export MANDIR=$TERMUX_PREFIX/share/man
}
