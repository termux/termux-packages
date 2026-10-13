TERMUX_PKG_HOMEPAGE=https://mujs.com/
TERMUX_PKG_DESCRIPTION="A lightweight Javascript interpreter designed for embedding in other software"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.10"
TERMUX_PKG_SRCURL="https://mujs.com/downloads/mujs-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6e36c15dbb84ff859320297c900852f241b131a7b6ddaea669ac9a65bd75571c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="HAVE_READLINE=yes"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
}
