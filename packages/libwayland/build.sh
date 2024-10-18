TERMUX_PKG_HOMEPAGE=https://wayland.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Wayland protocol library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/wayland/wayland/-/releases/${TERMUX_PKG_VERSION}/downloads/wayland-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1540af1ea698a471c2d8e9d288332c7e0fd360c8f1d12936ebb7e7cbc2425842
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
	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP

	${TERMUX_MESON} ${TERMUX_PKG_SRCDIR} . \
		${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	ninja -j "${TERMUX_PKG_MAKE_PROCESSES}" install
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/cross/bin:$PATH"
}
