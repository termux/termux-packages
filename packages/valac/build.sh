TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DEPENDS="clang, glib-dev, pkg-config"
TERMUX_PKG_VERSION=0.40.7
TERMUX_PKG_SHA256=bee662f60ab3a0d5266c1dd66f508cd9ed3254d74622d23c2d6bd94c91990aec
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION:0:4}/vala-$TERMUX_PKG_VERSION.tar.xz

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f vala-0.40/libvalaccodegen.so libvalaccodegen.so
}
