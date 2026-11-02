TERMUX_PKG_HOMEPAGE=https://github.com/spk121/guile-gi
TERMUX_PKG_DESCRIPTION="GObject introspection bindings for Guile"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=0.3.2
TERMUX_PKG_SRCURL=https://github.com/spk121/guile-gi/releases/download/v${TERMUX_PKG_VERSION}/guile_gi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7e35b9b661e331a45bc44f4e4093b748693c603de94d728098a7a8e71f5c3505
TERMUX_PKG_DEPENDS="glib, gobject-introspection, guile, libffi"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]]; then
		make -j "$TERMUX_PKG_MAKE_PROCESSES" BUILT_SOURCES=
		return
	fi
	make -j "$TERMUX_PKG_MAKE_PROCESSES" BUILT_SOURCES= libguile-gi.la
	mv .libs/libguile-gi.so .libs/libguile-gi.so.target
	local _HOST_PKG_CONFIG_LIBDIR=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
	gcc -shared -fPIC -DHAVE_CONFIG_H -I. -I./src \
		$(PKG_CONFIG_LIBDIR=$_HOST_PKG_CONFIG_LIBDIR /usr/bin/pkg-config --cflags guile-3.0 glib-2.0 gobject-2.0 gobject-introspection-1.0 libffi) \
		-o .libs/libguile-gi.so src/*.c \
		$(PKG_CONFIG_LIBDIR=$_HOST_PKG_CONFIG_LIBDIR /usr/bin/pkg-config --libs guile-3.0 glib-2.0 gobject-2.0 gobject-introspection-1.0 libffi)
	make -j "$TERMUX_PKG_MAKE_PROCESSES" BUILT_SOURCES=
	mv .libs/libguile-gi.so.target .libs/libguile-gi.so
}

termux_step_make_install() {
	make install BUILT_SOURCES=
}
