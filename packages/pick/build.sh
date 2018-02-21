TERMUX_PKG_HOMEPAGE=https://github.com/calleerlandsson/pick
TERMUX_PKG_DESCRIPTION="Utility to choose one option from a set of choices with fuzzy search functionality"
TERMUX_PKG_VERSION=2.0.1
TERMUX_PKG_SHA256=4a596b8f40a316bc4e2c0d8e8842810d7a7b69d464a410e4ee2a6574e01629e3
TERMUX_PKG_SRCURL=https://github.com/calleerlandsson/pick/releases/download/v${TERMUX_PKG_VERSION}/pick-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_search_setupterm=-lncurses"
