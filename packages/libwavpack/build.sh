TERMUX_PKG_HOMEPAGE=https://www.wavpack.com/
TERMUX_PKG_DESCRIPTION="A completely open audio compression format providing lossless, high-quality lossy, and a unique hybrid compression mode"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.8.0"
TERMUX_PKG_SRCURL=https://github.com/dbry/WavPack/releases/download/${TERMUX_PKG_VERSION}/wavpack-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a6a7dcd2262a21fa738e831ddd5e65e523b663308031cbd8a925e3b534809f0f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
