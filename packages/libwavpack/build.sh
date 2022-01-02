TERMUX_PKG_HOMEPAGE=https://www.wavpack.com/
TERMUX_PKG_DESCRIPTION="A completely open audio compression format providing lossless, high-quality lossy, and a unique hybrid compression mode"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.0
TERMUX_PKG_SRCURL=https://github.com/dbry/WavPack/releases/download/${TERMUX_PKG_VERSION}/wavpack-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4bde6a6b2a86614a6bd2579e60dcc974e2c8f93608d2281110a717c1b3c28b79
TERMUX_PKG_DEPENDS="libandroid-glob, libiconv"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
