TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.56
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${_MAJOR_VERSION}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=862c41d938543ed3d8d86c8219a61087797193defee8da0c50caf49993c66b6a
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_RECOMMENDS="clang, pkg-config"
TERMUX_PKG_BREAKS="valac-dev"
TERMUX_PKG_REPLACES="valac-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-cgraph=no"

termux_step_post_make_install() {
	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1-2)
	ln -sf vala-${v}/libvalaccodegen.so $TERMUX_PREFIX/lib/libvalaccodegen.so
}
