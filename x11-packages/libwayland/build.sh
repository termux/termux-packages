TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocol library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.17.0
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://wayland.freedesktop.org/releases/wayland-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=72aa11b8ac6e22f4777302c9251e8fec7655dc22f9d94ee676c6b276f95f91a4
TERMUX_PKG_DEPENDS="libandroid-support, libffi, libxml2, libexpat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-documentation --with-host-scanner"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
--disable-libraries
--disable-documentation
--disable-dtd-validation
--prefix=$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/cross
"

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure" ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -j "$TERMUX_MAKE_PROCESSES"
	make install
}

termux_step_pre_configure() {
	autoreconf -fi

	_HOST_PREFIX=$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/cross
	export PATH=${_HOST_PREFIX}/bin:$PATH
}

termux_step_post_make_install() {
	sed -i 's/wayland_scanner=${exec_prefix}\/bin\/wayland-scanner/wayland_scanner=\/usr\/bin\/wayland-scanner/g' $TERMUX_PREFIX/lib/pkgconfig/wayland-scanner.pc
}
