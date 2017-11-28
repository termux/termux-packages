TERMUX_PKG_HOMEPAGE=https://www.opus-codec.org/
TERMUX_PKG_DESCRIPTION="A high-level API for decoding and seeking within .opus files"
TERMUX_PKG_VERSION=0.10
TERMUX_PKG_SHA256=48e03526ba87ef9cf5f1c47b5ebe3aa195bd89b912a57060c36184a6cd19412f
TERMUX_PKG_SRCURL=https://github.com/xiph/opusfile/releases/download/v${TERMUX_PKG_VERSION}/opusfile-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libopus, libogg"
