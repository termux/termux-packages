TERMUX_PKG_HOMEPAGE=https://gitlab.com/nick87720z/tint2
TERMUX_PKG_DESCRIPTION="Lightweight panel, Highly customizable"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=17.1.3
TERMUX_PKG_SRCURL=https://gitlab.com/nick87720z/tint2/-/archive/v${TERMUX_PKG_VERSION}/tint2-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=283e193c3bed452e9d2ecbc64c21303ca3e3cc8a5f0a1e16550cbdae97514a23
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, imlib2, libandroid-shmem, libandroid-wordexp, libcairo, librsvg, libx11, libxcomposite, libxdamage, libxext, libxinerama, libxrandr, libxrender, pango, startup-notification"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem -landroid-wordexp"
}
