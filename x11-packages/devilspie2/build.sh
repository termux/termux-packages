TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/devilspie2/
TERMUX_PKG_DESCRIPTION="A window-matching utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.45"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.savannah.nongnu.org/releases/devilspie2/devilspie2_${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=6cc55a68ccfd8bb5620f4cd7c9913ef29aba8a9e96648497c5b448fdb97cb034
TERMUX_PKG_DEPENDS="glib, gtk3, lua54, libwnck, libx11, libxinerama, libxrandr"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="LUA=lua54"

termux_step_post_configure() {
	mkdir -p obj
}
