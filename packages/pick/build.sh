TERMUX_PKG_HOMEPAGE=https://github.com/calleerlandsson/pick
TERMUX_PKG_DESCRIPTION="Utility to choose one option from a set of choices with fuzzy search functionality"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SHA256=b2d0384c376b697b7e8f17843485e6373514f001b35be18b6414a2fd5ced8d9b
TERMUX_PKG_SRCURL=https://github.com/calleerlandsson/pick/releases/download/v${TERMUX_PKG_VERSION}/pick-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_search_setupterm=-lncurses"
