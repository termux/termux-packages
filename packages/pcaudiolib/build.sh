TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/pcaudiolib
TERMUX_PKG_DESCRIPTION="Portable C Audio Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/pcaudiolib/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=44b9d509b9eac40a0c61585f756d76a7b555f732e8b8ae4a501c8819c59c6619
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
