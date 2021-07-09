TERMUX_PKG_HOMEPAGE=https://github.com/Arkq/cmusfm
TERMUX_PKG_DESCRIPTION="Last.fm standalone scrobbler for the cmus music player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_SRCURL=https://github.com/Arkq/cmusfm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d72e04df69c1f3e95f1b7779f583a790660856fadb5cfd8a2717c085b1b12111
TERMUX_PKG_DEPENDS=libcurl

termux_step_pre_configure() {
  autoreconf --install
}
