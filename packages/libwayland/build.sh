TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocol library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.23.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wayland/wayland/-/releases/${TERMUX_PKG_VERSION}/downloads/wayland-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=864fb2a8399e2d0ec39d56e9d9b753c093775beadc6022ce81f441929a81e5ed
TERMUX_PKG_DEPENDS="libandroid-support, libexpat, libffi, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocumentation=false
-Dtests=false
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
-Ddocumentation=false
-Ddtd_validation=false
-Dlibraries=false
-Dtests=false
--prefix ${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}/cross
"

termux_step_host_build() {
	# Download and unpack and build libexpat for host
	EXPAT_SRC="$TERMUX_PKG_SRCDIR/expat"
	EXPAT_PREFIX="$TERMUX_PKG_HOSTBUILD_DIR/expat"
	(. "$TERMUX_SCRIPTDIR/packages/libexpat/build.sh"; TERMUX_PKG_SRCDIR="$EXPAT_SRC" termux_step_get_source )
	(
		cd "$EXPAT_SRC"
		./configure --prefix="$EXPAT_PREFIX" --without-docbook
		make install
	)

	# XXX: termux_setup_meson is not expected to be called in host build
	export PKG_CONFIG_LIBDIR="$EXPAT_PREFIX/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig"
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP PKG_CONFIG_PATH

	${TERMUX_MESON} setup ${TERMUX_PKG_SRCDIR} . \
		${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	ninja -j "${TERMUX_PKG_MAKE_PROCESSES}" install
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/cross/bin:$PATH"
}
