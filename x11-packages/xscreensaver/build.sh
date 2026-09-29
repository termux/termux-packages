TERMUX_PKG_HOMEPAGE=https://www.jwz.org/xscreensaver
TERMUX_PKG_DESCRIPTION="Screen saver and OpenGL demos for the X Window System"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="debian/copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.16"
TERMUX_PKG_SRCURL="https://fossies.org/linux/misc/xscreensaver-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=91153c7c5b996761606dd7962c9f4bd4005a25874eac02776d0cf0026e6454e4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="at-spi2-core, gdk-pixbuf, glib, glu, gtk3, opengl, libandroid-shmem, libjpeg-turbo, libx11, libxext, libxft, libxi, libxml2, libxmu, libxrandr, libxt, libxxf86vm, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
--with-app-defaults=$TERMUX_PREFIX/etc/X11/app-defaults
--with-gl
--with-gtk
--with-jpeg
--with-pixbuf
--without-gle
--without-login-manager
--without-pam
--without-systemd
--disable-locking
"

termux_step_pre_configure() {
	aclocal
	autoconf

	termux_setup_glib_cross_pkg_config_wrapper

	LDFLAGS+=" -landroid-shmem"
}

termux_pkg_auto_update() {
	local latest
	latest="$(curl -fsSL "https://fossies.org/linux/misc/" | sed -rn 's/.*xscreensaver-([0-9]+(\.[0-9]+)*)\.tar\.gz.*/\1/p' | sort -Vr | head -n1)"
	termux_pkg_upgrade_version "${latest}"
}
