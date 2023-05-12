TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/devilspie2/
TERMUX_PKG_DESCRIPTION="A window-matching utility"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.44
TERMUX_PKG_SRCURL=https://download.savannah.nongnu.org/releases/devilspie2/devilspie2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0a9f1eadd2b22a318163e4180065d495221ba1a43ad2021ea6866cd118042640
TERMUX_PKG_DEPENDS="glib, gtk3, liblua54, libwnck, libx11, libxinerama"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="LUA=lua54"

termux_step_post_configure() {
	mkdir -p obj
}
