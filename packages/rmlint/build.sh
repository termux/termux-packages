TERMUX_PKG_HOMEPAGE=https://github.com/sahib/rmlint
TERMUX_PKG_DESCRIPTION="Extremely fast tool to find space waste and duplicate files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.4"
TERMUX_PKG_SRCURL=https://github.com/sahib/rmlint/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cecb379b64e2abad7350db7030b945b5b0d021e7f9a1e8f14725ebffe049d041
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, json-glib, libblkid, libelf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	scons \
		CC="$(command -v $CC)" \
		--prefix="$TERMUX_PREFIX" \
		--without-gui \
		install
}
