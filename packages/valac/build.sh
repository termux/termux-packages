TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_VERSION=0.38.7
TERMUX_PKG_SHA256=09d10f5f7d0e4b3c905d9f636cb5ac55f317494e42c75e6572be4138b0603405
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION:0:4}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="clang, glib-dev, pkg-config"

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f vala-0.38/libvalaccodegen.so libvalaccodegen.so
}
