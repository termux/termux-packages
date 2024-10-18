TERMUX_PKG_HOMEPAGE=http://www.lxde.org/
TERMUX_PKG_DESCRIPTION="LXTask is a GUI application for the Lightweight X11 Desktop Environment (LXDE)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="0.1.11"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxtask/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a28e1804f4d68e8698c012a4a7b30f5a18dfa4c3d54f4f667793af7d2ac27408
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="gtk3, glib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"
termux_step_pre_configure() {
	./autogen.sh
}
