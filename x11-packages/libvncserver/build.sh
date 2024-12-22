TERMUX_PKG_HOMEPAGE=https://libvnc.github.io/
TERMUX_PKG_DESCRIPTION="Cross-platform C libraries that allow you to easily implement VNC server or client functionality"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.15"
TERMUX_PKG_SRCURL=https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=62352c7795e231dfce044beb96156065a05a05c974e5de9e023d688d8ff675d7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="libgcrypt, libgnutls, libjpeg-turbo, liblzo, libpng, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWITH_OPENSSL=OFF
-DWITH_SASL=OFF
"

termux_step_post_massage() {
	local f
	for f in ./lib/pkgconfig/libvnc{client,server}.pc; do
		if [ -e "${f}" ]; then
			sed -i '/^Libs\.private:/s/ -l\(-pthread\)/ \1/' "${f}"
		fi
	done
}
