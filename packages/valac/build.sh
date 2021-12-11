TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.52.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION:0:4}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=037ea1a92bf0f1ab04a71b52a01d50aca1945ad1017b6189d9614f84f5c9b2d9
TERMUX_PKG_DEPENDS="clang, glib, pkg-config"
TERMUX_PKG_BREAKS="valac-dev"
TERMUX_PKG_REPLACES="valac-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-cgraph=no"

termux_step_post_make_install() {
	cd ${TERMUX_PREFIX}/lib
	ln -s -f vala-${TERMUX_PKG_VERSION:0:4}/libvalaccodegen.so libvalaccodegen.so
}
