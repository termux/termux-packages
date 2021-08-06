TERMUX_PKG_HOMEPAGE=https://github.com/Arkq/cmusfm
TERMUX_PKG_DESCRIPTION="Last.fm standalone scrobbler for the cmus music player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.1
TERMUX_PKG_SRCURL=https://github.com/Arkq/cmusfm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff5338d4b473a3e295f3ae4273fb097c0f79c42e3d803eefdf372b51dba606f2
TERMUX_PKG_DEPENDS=libcurl

termux_step_pre_configure() {
  autoreconf --install
}
