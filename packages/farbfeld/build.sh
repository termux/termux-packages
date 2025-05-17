
TERMUX_PKG_HOMEPAGE=https://tools.suckless.org/farbfeld/
TERMUX_PKG_DESCRIPTION="conversion tools for farbfelt, like netpbm without the complexity"
TERMUX_PKG_LICENSE="ISC"

TERMUX_PKG_MAINTAINER="@termux"

TERMUX_PKG_VERSION=4
TERMUX_PKG_SRCURL=https://dl.suckless.org/farbfeld/farbfeld-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c7df5921edd121ca5d5b1cf6fb01e430aff9b31242262e4f690d3af72ccbe72a

TERMUX_PKG_DEPENDS=libjpeg-turbo,libpng
# The 2ff(1) script just uses convert(1) to convert to png and then png2ff(1) to convert to farbfeld.
# Without convert(1), we can't even convert PNM to farbfeld!
TERMUX_PKG_RECOMMENDS=imagemagick

# plain Makefile; doesn't seem to support out-of-tree builds?
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# Need to pass these on command line to override settings in config.mk,
	# but they aren't available before configure
	TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=${TERMUX_PREFIX} CC=${CC} LD=${LD}"
}
