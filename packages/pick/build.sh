TERMUX_PKG_HOMEPAGE=https://github.com/thoughtbot/pick
TERMUX_PKG_DESCRIPTION="Utility to choose one option from a set of choices with fuzzy search functionality"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_SRCURL=https://github.com/thoughtbot/pick/releases/download/v${TERMUX_PKG_VERSION}/pick-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
TERMUX_PKG_DEPENDS="ncurses"
