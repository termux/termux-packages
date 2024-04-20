TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/vte/
TERMUX_PKG_DESCRIPTION="Virtual Terminal library"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING.GPL3, COPYING.LGPL3, COPYING.XTERM"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:0.74.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/vte/-/archive/${TERMUX_PKG_VERSION:2}/vte-${TERMUX_PKG_VERSION:2}.tar.bz2
#TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/vte/${_MAJOR_VERSION}/vte-${_VERSION}.tar.xz
TERMUX_PKG_SHA256=2a1162738c9bccfac1bb801125c1889d3980d857499909439803cf1def4c25d1
TERMUX_PKG_DEPENDS="atk, fribidi, gdk-pixbuf, gtk3, gtk4, libc++, libcairo, libgnutls, libicu, pango, pcre2, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=true
-Dvapi=false
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

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

	CPPFLAGS+=" -DLINE_MAX=_POSIX2_LINE_MAX -Wno-cast-function-type-strict -Wno-deprecated-declarations -Wno-cast-function-type"
}
