TERMUX_PKG_HOMEPAGE=https://speex.org/
TERMUX_PKG_DESCRIPTION="Speex audio processing library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SRCURL=https://github.com/xiph/speexdsp/archive/SpeexDSP-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d17ca363654556a4ff1d02cc13d9eb1fc5a8642c90b40bd54ce266c3807b91a7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_BREAKS="speexdsp-dev"
TERMUX_PKG_REPLACES="speexdsp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon"
TERMUX_PKG_RM_AFTER_INSTALL="share/doc/speexdsp/manual.pdf"

termux_step_pre_configure() {
	./autogen.sh
}
