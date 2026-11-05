TERMUX_PKG_HOMEPAGE=https://github.com/sahib/rmlint
TERMUX_PKG_DESCRIPTION="Extremely fast tool to find space waste and duplicate files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL=https://github.com/sahib/rmlint/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e7a20caf7f0162791f947a89931de76750daadd72be7719477278f3e949f00df
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, json-glib, libblkid, libelf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=unused-variable"
}

termux_step_make_install() {
	scons \
		CC="$(command -v $CC)" \
		PREFIX="$TERMUX_PREFIX" \
		--without-gui \
		install
}
