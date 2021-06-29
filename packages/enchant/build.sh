TERMUX_PKG_HOMEPAGE=https://abiword.github.io/enchant/
TERMUX_PKG_DESCRIPTION="Wraps a number of different spelling libraries and programs with a consistent interface."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/AbiWord/enchant/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9b03d836f93a221b06334919227ccf4354796a9b05fb91340956fd12f0a4d57
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-relocatable" 
TERMUX_PKG_DEPENDS="glib"

termux_step_post_get_source() {
	./bootstrap
}
