TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_VERSION=0.40.4
TERMUX_PKG_SHA256=379354a2a2f7ee5c4d6e0f5e88b0e32620dcd5f51972baf6d90d9f18eb689198
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION:0:4}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="clang, glib-dev, pkg-config"

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f vala-0.38/libvalaccodegen.so libvalaccodegen.so
}
