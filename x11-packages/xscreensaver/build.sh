TERMUX_PKG_HOMEPAGE=https://www.jwz.org/xscreensaver
TERMUX_PKG_DESCRIPTION="Screen saver and OpenGL demos for the X Window System"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="debian/copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.15"
TERMUX_PKG_SRCURL="https://www.jwz.org/xscreensaver/xscreensaver-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d2e687e56263fbfd8fca1fb9cc7c9331fd4f096ab57d3f7482565fe012c362d3
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
	termux_setup_glib_cross_pkg_config_wrapper

	LDFLAGS+=" -landroid-shmem"
}
