TERMUX_PKG_HOMEPAGE=https://github.com/calleerlandsson/pick
TERMUX_PKG_DESCRIPTION="Utility to choose one option from a set of choices with fuzzy search functionality"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://github.com/calleerlandsson/pick/releases/download/v${TERMUX_PKG_VERSION}/pick-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d034fd75256ccb3e8c6523196ac250b44b18170a6594944ed6d23d1bcabfae6a
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_search_setupterm=-lncurses"
