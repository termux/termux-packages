TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libsecret
TERMUX_PKG_DESCRIPTION="A GObject-based library for accessing the Secret Service API"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION="0.21.4"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsecret/${TERMUX_PKG_VERSION%.*}/libsecret-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=163d08d783be6d4ab9a979ceb5a4fecbc1d9660d3c34168c581301cd53912b20
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libgcrypt"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
-Dintrospection=true
"

termux_step_pre_configure() {
	termux_setup_gir

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

	# https://gitlab.gnome.org/GNOME/vala/-/issues/1413
	CPPFLAGS+=" -Wno-incompatible-function-pointer-types"
}
