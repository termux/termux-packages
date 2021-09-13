TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/bison/
TERMUX_PKG_DESCRIPTION="General-purpose parser generator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.8.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/bison/bison-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=31fc602488aad6bdecf0ccc556e0fc72fc57cdc595cf92398f020e0cf4980f15
TERMUX_PKG_DEPENDS="m4"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
M4=m4
ac_cv_header_spawn_h=no
"

TERMUX_PKG_RM_AFTER_INSTALL="share/info/dir"
