TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.56.18"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION%.*}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f2affe7d40ab63db8e7b9ecc3f6bdc9c2fc7e3134c84ff2d795f482fe926a382
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
