TERMUX_PKG_HOMEPAGE=https://github.com/Arkq/cmusfm
TERMUX_PKG_DESCRIPTION="Last.fm standalone scrobbler for the cmus music player"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Arkq/cmusfm/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9d9fa7df01c3dd7eecd72656e61494acc3b0111c07ddb18be0ad233110833b63
TERMUX_PKG_DEPENDS=libcurl

termux_step_pre_configure() {
  autoreconf --install
}
