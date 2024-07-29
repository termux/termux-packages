TERMUX_PKG_HOMEPAGE=https://keep.imfreedom.org/libgnt/libgnt
TERMUX_PKG_DESCRIPTION="An ncurses toolkit for creating text-mode graphical user interfaces in a fast and easy way"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/pidgin/libgnt/${TERMUX_PKG_VERSION}/libgnt-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=57f5457f72999d0bb1a139a37f2746ec1b5a02c094f2710a339d8bcea4236123
TERMUX_PKG_DEPENDS="glib, libxml2, ncurses"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Ddoc=false -Dpython2=false"

termux_step_pre_configure() {
	local _WRAPPER_BIN="${TERMUX_PKG_BUILDDIR}/_wrapper/bin"
	mkdir -p "${_WRAPPER_BIN}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		sed "s|^export PKG_CONFIG_LIBDIR=|export PKG_CONFIG_LIBDIR=${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig:|" \
			"${TERMUX_STANDALONE_TOOLCHAIN}/bin/pkg-config" \
			> "${_WRAPPER_BIN}/pkg-config"
		chmod +x "${_WRAPPER_BIN}/pkg-config"
		export PKG_CONFIG="${_WRAPPER_BIN}/pkg-config"
	fi
	export PATH="${_WRAPPER_BIN}:${PATH}"
}
