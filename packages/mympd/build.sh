TERMUX_PKG_HOMEPAGE=https://jcorporation.github.io/myMPD/
TERMUX_PKG_DESCRIPTION="A standalone and lightweight web-based MPD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.1.6
TERMUX_PKG_SRCURL=https://github.com/jcorporation/myMPD/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eddeec8e598aca50e47d6da7f09103f2772d763abb65df7da2599013056a00ef
TERMUX_PKG_DEPENDS="libflac, libid3tag, openssl, pcre, resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -I$TERMUX_PKG_SRCDIR/release"

	ln -sfT ../dist src/dist
	sh build.sh createassets
	cd release
}
