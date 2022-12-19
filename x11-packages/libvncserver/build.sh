TERMUX_PKG_HOMEPAGE=https://libvnc.github.io/
TERMUX_PKG_DESCRIPTION="Cross-platform C libraries that allow you to easily implement VNC server or client functionality"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.14
TERMUX_PKG_SRCURL=https://github.com/LibVNC/libvncserver/archive/LibVNCServer-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=83104e4f7e28b02f8bf6b010d69b626fae591f887e949816305daebae527c9a5
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
