TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.56.16"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION%.*}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=05487b5600f5d2f09e66a753cccd8f39c1bff9f148aea1b7774d505b9c8bca9b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_RECOMMENDS="clang, pkg-config"
TERMUX_PKG_BREAKS="valac-dev"
TERMUX_PKG_REPLACES="valac-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-cgraph=no"

termux_step_post_make_install() {
	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1-2)
	ln -sf vala-${v}/libvalaccodegen.so $TERMUX_PREFIX/lib/libvalaccodegen.so
}
