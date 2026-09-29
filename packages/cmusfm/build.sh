TERMUX_PKG_HOMEPAGE=https://github.com/Arkq/cmusfm
TERMUX_PKG_DESCRIPTION="Last.fm standalone scrobbler for the cmus music player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Arkq/cmusfm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17aae8fc805e79b367053ad170854edceee5f4c51a9880200d193db9862d8363
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libandroid-spawn, libcurl, openssl"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
	autoreconf --force --install
}
