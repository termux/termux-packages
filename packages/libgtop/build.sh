TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libgtop
TERMUX_PKG_DESCRIPTION="Library for collecting system monitoring data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.41.3"
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/libgtop/-/archive/${TERMUX_PKG_VERSION}/libgtop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2136f5586377706c267b61c04c3f59ada69d59d83fc8967f137813a8503d0fa7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libandroid-shmem, libxau"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk-doc-html=no
--enable-introspection=yes
--without-examples
"

termux_step_post_get_source() {
	sed -i "s|/proc/stat|${TERMUX_PREFIX}/var/libgtop/stat|g" $(grep -rl "/proc/stat")
	rm sysdeps/linux/sem_limits.c
	cp sysdeps/{stub,linux}/sem_limits.c
}

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
	NOCONFIGURE=1 ./autogen.sh
	LDFLAGS+=" -landroid-shmem"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/var/libgtop
	cp -a $TERMUX_PKG_BUILDER_DIR/procstat $TERMUX_PREFIX/var/libgtop/stat
}
