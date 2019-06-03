TERMUX_PKG_HOMEPAGE=https://speex.org/
TERMUX_PKG_DESCRIPTION="Speex audio processing library"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.2rc3
TERMUX_PKG_SHA256=4ae688600039f5d224bdf2e222d2fbde65608447e4c2f681585e4dca6df692f1
TERMUX_PKG_SRCURL=http://downloads.xiph.org/releases/speex/speexdsp-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-neon"
TERMUX_PKG_RM_AFTER_INSTALL="share/doc/speexdsp/manual.pdf"
