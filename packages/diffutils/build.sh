TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/diffutils/
TERMUX_PKG_DESCRIPTION="Programs (cmp, diff, diff3 and sdiff) related to finding differences between files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="3.12"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/diffutils/diffutils-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7c8b7f9fc8609141fdea9cece85249d308624391ff61dedaf528fcb337727dfd
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_ESSENTIAL=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_func_strcasecmp_works=yes
ac_cv_path_PR_PROGRAM=${TERMUX_PREFIX}/bin/pr
"
