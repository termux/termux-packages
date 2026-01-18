TERMUX_PKG_HOMEPAGE=https://www.wavpack.com/
TERMUX_PKG_DESCRIPTION="A completely open audio compression format providing lossless, high-quality lossy, and a unique hybrid compression mode"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.9.0"
TERMUX_PKG_SRCURL=https://github.com/dbry/WavPack/releases/download/${TERMUX_PKG_VERSION}/wavpack-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b5291bc4e6d69ebbd3da3800c5bf4a70f19bb92679b23e09b3b612c1e648d1ff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
