TERMUX_PKG_HOMEPAGE=https://gitlab.com/ajs124/abootimg
TERMUX_PKG_DESCRIPTION="Pack or unpack android boot images"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.com/ajs124/abootimg/-/archive/v${TERMUX_PKG_VERSION}/abootimg-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1dde5cadb8a14fccc677e5422d32c969a49c705daa03ce9b69af941247ff7cde
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="util-linux, libblkid"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source () {
	echo "#define VERSION_STR \"$TERMUX_PKG_VERSION\"" > $TERMUX_PKG_SRCDIR/version.h
	touch -d "next hour" $TERMUX_PKG_SRCDIR/version.h
}
