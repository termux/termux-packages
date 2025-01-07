TERMUX_PKG_HOMEPAGE=https://www.avahi.org/
TERMUX_PKG_DESCRIPTION="A system for service discovery on a local network via mDNS/DNS-SD"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://github.com/lathiat/avahi/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c15e750ef7c6df595fb5f2ce10cac0fee2353649600e6919ad08ae8871e4945f
TERMUX_PKG_DEPENDS="dbus, glib, libandroid-glob, libdaemon, libevent, libexpat, resolv-conf"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-compat-libdns_sd
--enable-dbus
--enable-introspection=yes
--disable-gdbm
--disable-gtk3
--disable-mono
--disable-pygobject
--disable-python
--disable-python-dbus
--disable-qt5
--with-distro=none
ac_cv_func_chroot=no
"
termux_step_pre_configure() {
	termux_setup_gir

	autoreconf -fi
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install() {
	ln -sf avahi-compat-libdns_sd/dns_sd.h $TERMUX_PREFIX/include/dns_sd.h
}
