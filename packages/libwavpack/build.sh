TERMUX_PKG_HOMEPAGE=https://www.wavpack.com/
TERMUX_PKG_DESCRIPTION="A completely open audio compression format providing lossless, high-quality lossy, and a unique hybrid compression mode"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.8.1"
TERMUX_PKG_SRCURL=https://github.com/dbry/WavPack/releases/download/${TERMUX_PKG_VERSION}/wavpack-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7322775498602c8850afcfc1ae38f99df4cbcd51386e873d6b0f8047e55c0c26
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
