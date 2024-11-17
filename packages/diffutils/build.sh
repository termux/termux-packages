TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/diffutils/
TERMUX_PKG_DESCRIPTION="Programs (cmp, diff, diff3 and sdiff) related to finding differences between files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/diffutils/diffutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=90e5e93cc724e4ebe12ede80df1634063c7a855692685919bfe60b556c9bd09e
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_PR_PROGRAM=${TERMUX_PREFIX}/bin/pr"
