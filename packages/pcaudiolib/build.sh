TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/pcaudiolib
TERMUX_PKG_DESCRIPTION="Portable C Audio Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/pcaudiolib/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=699a5a347b1e12dc5b122e192e19f4db01621826bf41b9ebefb1cbc63ae2180b
TERMUX_PKG_DEPENDS="pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}
