TERMUX_PKG_HOMEPAGE=https://github.com/sahib/rmlint
TERMUX_PKG_DESCRIPTION="Extremely fast tool to find space waste and duplicate files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.3"
TERMUX_PKG_SRCURL=https://github.com/sahib/rmlint/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ffdbd5d09d15c8717ae55497e90d6fa46f085b45ac1056f2727076da180c33e
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
