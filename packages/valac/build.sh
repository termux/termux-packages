TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DEPENDS="clang, glib-dev, pkg-config"
TERMUX_PKG_VERSION=0.40.6
TERMUX_PKG_SHA256=6da450f1a73e0f1e17506e68cce5b9e8996349e576d3f8cb6b0b73ee22e44be2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION:0:4}/vala-$TERMUX_PKG_VERSION.tar.xz

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f vala-0.40/libvalaccodegen.so libvalaccodegen.so
}
