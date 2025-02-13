TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/diffutils/
TERMUX_PKG_DESCRIPTION="Programs (cmp, diff, diff3 and sdiff) related to finding differences between files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.11"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/diffutils/diffutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a73ef05fe37dd585f7d87068e4a0639760419f810138bd75c61ddaa1f9e2131e
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_PR_PROGRAM=${TERMUX_PREFIX}/bin/pr"
