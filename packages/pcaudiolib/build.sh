TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/pcaudiolib
TERMUX_PKG_DESCRIPTION="Portable C Audio Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/pcaudiolib/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=82bb8df1cbaee6abca6f3e8698521cc398eba2284dde1fade07d72517eb34a2f
TERMUX_PKG_DEPENDS="pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
