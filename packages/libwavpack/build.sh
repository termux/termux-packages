TERMUX_PKG_HOMEPAGE=https://www.wavpack.com/
TERMUX_PKG_DESCRIPTION="A completely open audio compression format providing lossless, high-quality lossy, and a unique hybrid compression mode"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.7.0"
TERMUX_PKG_SRCURL=https://github.com/dbry/WavPack/releases/download/${TERMUX_PKG_VERSION}/wavpack-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e81510fd9ec5f309f58d5de83e9af6c95e267a13753d7e0bbfe7b91273a88bee
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
