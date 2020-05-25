TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bison/
TERMUX_PKG_DESCRIPTION="General-purpose parser generator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=3.6.2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bison/bison-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4a164b5cc971b896ce976bf4b624fab7279e0729cf983a5135df7e4df0970f6e
TERMUX_PKG_DEPENDS="m4"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
M4=m4
ac_cv_header_spawn_h=no
"

TERMUX_PKG_RM_AFTER_INSTALL="share/info/dir"
