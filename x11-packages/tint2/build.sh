TERMUX_PKG_HOMEPAGE=https://gitlab.com/o9000/tint2
TERMUX_PKG_DESCRIPTION="Lightweight panel, Highly customizable"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=17.0.2
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://gitlab.com/o9000/tint2/-/archive/${TERMUX_PKG_VERSION}/tint2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f87f147e176d32f31f12fc1737f75f54c4c6f77961c6a2615ef9d64cb29ce24c
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, imlib2, libandroid-shmem, libandroid-wordexp, libcairo, librsvg, libx11, libxcomposite, libxdamage, libxext, libxinerama, libxrandr, libxrender, pango, startup-notification"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem -landroid-wordexp"
}
