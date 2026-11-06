TERMUX_PKG_HOMEPAGE=https://github.com/lxde/lxsession
TERMUX_PKG_DESCRIPTION="Lightweight X11 session manager (part of LXDE)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="0.5.7"
TERMUX_PKG_SRCURL=https://github.com/lxde/lxsession/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=150dd1b78bb663775cd499a452817f8de9ae79b154c5c765d457d6f54daa608b
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libpolkit, libx11"
TERMUX_PKG_BUILD_DEPENDS="valac"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3 --enable-buildin-clipboard"

termux_step_pre_configure() {
	./autogen.sh
}
