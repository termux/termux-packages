TERMUX_PKG_HOMEPAGE=https://github.com/calleerlandsson/pick
TERMUX_PKG_DESCRIPTION="Utility to choose one option from a set of choices with fuzzy search functionality"
TERMUX_PKG_VERSION=1.8.0
TERMUX_PKG_SHA256=7834d3aef9e575ce07414f961d1f024776b49bb23c5dc3b7bb8f6b734131067d
TERMUX_PKG_SRCURL=https://github.com/calleerlandsson/pick/releases/download/v${TERMUX_PKG_VERSION}/pick-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_search_setupterm=-lncurses"
