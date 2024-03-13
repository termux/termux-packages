TERMUX_PKG_HOMEPAGE=https://hexchat.github.io/
TERMUX_PKG_DESCRIPTION="A popular and easy to use graphical IRC (chat) client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.16.2"
TERMUX_PKG_SRCURL=https://github.com/hexchat/hexchat/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=486d73cdb6a89fa91cfbe242107901d06e777bea25956a7786c4a831a2caa0e3
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk2, liblua53, libx11, openssl, pango, python"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_PYTHON_COMMON_DEPS="cffi"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibcanberra=disabled
-Ddbus=disabled
-Dwith-lua=lua53
-Dtext-frontend=true
-Dwith-perl=false
-Dwith-sysinfo=false
"

TERMUX_PKG_RM_AFTER_INSTALL="share/locale"

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
