## This is stripped down version of 'libfm' package.
## Primarily used for compiling 'menu-cache'.

TERMUX_PKG_HOMEPAGE=https://github.com/lxde/libfm
TERMUX_PKG_DESCRIPTION="Extra library for file management"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://github.com/lxde/libfm/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1dff59162eb1ca5d1a6b945de4d0bdf2256a5264f54c9225b8599adce45dcb05
TERMUX_PKG_DEPENDS="glib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-extra-only
"

termux_step_pre_configure() {
	./autogen.sh
}
