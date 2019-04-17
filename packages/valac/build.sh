TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Vala
TERMUX_PKG_DESCRIPTION="C# like language for the GObject system"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DEPENDS="clang, glib-dev, pkg-config"
TERMUX_PKG_VERSION=0.44.3
TERMUX_PKG_SHA256=8553b422484af88be1685d8b47f7b0df36ae4477c3e77e89ab22276ffed1eae9
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/vala/${TERMUX_PKG_VERSION:0:4}/vala-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-cgraph=no"

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f vala-${TERMUX_PKG_VERSION:0:4}/libvalaccodegen.so libvalaccodegen.so
}
