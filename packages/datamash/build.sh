TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/datamash/
TERMUX_PKG_DESCRIPTION="Program performing numeric, textual and statistical operations"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/datamash/datamash-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f382ebda03650dd679161f758f9c0a6cc9293213438d4a77a8eda325aacb87d2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_func_strcasecmp_works=yes
"
