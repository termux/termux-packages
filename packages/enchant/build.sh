TERMUX_PKG_HOMEPAGE=https://abiword.github.io/enchant/
TERMUX_PKG_DESCRIPTION="Wraps a number of different spelling libraries and programs with a consistent interface."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/AbiWord/enchant/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f176aba971c7bf60f9bfe18937b77f566a06a38e2b9c4d9d481d3e73b308e6f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-relocatable" 
TERMUX_PKG_DEPENDS="glib"

termux_step_post_get_source() {
	./bootstrap
}
