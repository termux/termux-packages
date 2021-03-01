TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org 75dpi fonts"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=24
TERMUX_PKG_SRCURL=("https://xorg.freedesktop.org/releases/individual/font/font-adobe-75dpi-1.0.3.tar.bz2"
                   "https://xorg.freedesktop.org/releases/individual/font/font-adobe-utopia-75dpi-1.0.4.tar.bz2"
                   "https://xorg.freedesktop.org/releases/individual/font/font-bh-75dpi-1.0.3.tar.bz2"
                   "https://xorg.freedesktop.org/releases/individual/font/font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2"
                   "https://xorg.freedesktop.org/releases/individual/font/font-bitstream-75dpi-1.0.3.tar.bz2")
TERMUX_PKG_SHA256=("c6024a1e4a1e65f413f994dd08b734efd393ce0a502eb465deb77b9a36db4d09"
                   "8732719c61f3661c8bad63804ebfd54fc7de21ab848e9a26a19b1778ef8b5c94"
                   "3486aa51ac92c646a448fe899c5c3dae0024b1fef724d5100d52640d1cac721c"
                   "4ac16afbe205480cc5572e2977ea63488c543d05be0ea8e5a94c845a6eebcb31"
                   "ba3f5e4610c07bd5859881660753ec6d75d179f26fc967aa776dbb3d5d5cf48e")
TERMUX_PKG_DEPENDS="fontconfig-utils, xorg-font-util, xorg-fonts-alias, xorg-fonts-encodings, xorg-mkfontscale"
TERMUX_PKG_CONFLICTS="xorg-fonts-lite"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_get_source() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	local i
	for i in {0..4}; do
		termux_download "${TERMUX_PKG_SRCURL[i]}" "$(basename "${TERMUX_PKG_SRCURL[i]}")" "${TERMUX_PKG_SHA256[i]}"
		tar xf "$(basename "${TERMUX_PKG_SRCURL[i]}")" -C "${TERMUX_PKG_SRCDIR}"
	done
}

termux_step_make_install() {
	local i
	for i in {0..4}; do
		local file=$(basename "${TERMUX_PKG_SRCURL[i]}")
		local dir="${TERMUX_PKG_SRCDIR}/${file%%.tar.bz2}"

		pushd "${dir}"
		./configure \
			--prefix="${TERMUX_PREFIX}" \
			--host="${TERMUX_HOST_PLATFORM}" \
			--with-fontdir="${TERMUX_PREFIX}/share/fonts/75dpi"
		make -j "${TERMUX_MAKE_PROCESSES}"
		make install
		popd
	done
}

termux_step_post_make_install() {
	rm -f "${TERMUX_PREFIX}"/share/fonts/75dpi/fonts.*
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/xorg-fonts-75dpi $TERMUX_PKG_BUILDER_DIR/COPYING
}
