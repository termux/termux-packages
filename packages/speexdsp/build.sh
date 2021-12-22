TERMUX_PKG_HOMEPAGE=https://speex.org/
TERMUX_PKG_DESCRIPTION="Speex audio processing library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/xiph/speexdsp/archive/SpeexDSP-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d7032f607e8913c019b190c2bccc36ea73fc36718ee38b5cdfc4e4c0a04ce9a4
TERMUX_PKG_BREAKS="speexdsp-dev"
TERMUX_PKG_REPLACES="speexdsp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon"
TERMUX_PKG_RM_AFTER_INSTALL="share/doc/speexdsp/manual.pdf"

termux_step_pre_configure() {
	./autogen.sh
}
