TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org 75dpi fonts"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=22
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="fontconfig-utils, xorg-font-util, xorg-fonts-alias, xorg-fonts-encodings, xorg-mkfontscale"
TERMUX_PKG_CONFLICTS="xorg-fonts-lite"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

font_sources=("font-adobe-75dpi-1.0.3.tar.bz2"
              "font-adobe-utopia-75dpi-1.0.4.tar.bz2"
              "font-bh-75dpi-1.0.3.tar.bz2"
              "font-bh-lucidatypewriter-75dpi-1.0.3.tar.bz2"
              "font-bitstream-75dpi-1.0.3.tar.bz2")

font_sources_sha256=("c6024a1e4a1e65f413f994dd08b734efd393ce0a502eb465deb77b9a36db4d09"
                     "8732719c61f3661c8bad63804ebfd54fc7de21ab848e9a26a19b1778ef8b5c94"
                     "3486aa51ac92c646a448fe899c5c3dae0024b1fef724d5100d52640d1cac721c"
                     "4ac16afbe205480cc5572e2977ea63488c543d05be0ea8e5a94c845a6eebcb31"
                     "ba3f5e4610c07bd5859881660753ec6d75d179f26fc967aa776dbb3d5d5cf48e")

termux_step_post_extract_package() {
	local _base_url="https://xorg.freedesktop.org/releases/individual/font"

	for i in {0..4}; do
		local url="${_base_url}/${font_sources[i]}"
		local file="${TERMUX_PKG_CACHEDIR}/${font_sources[i]}"
		local checksum="${font_sources_sha256[i]}"

		termux_download "${url}" "${file}" "${checksum}"
		tar xf "${file}" -C "${TERMUX_PKG_SRCDIR}"
	done
}

termux_step_pre_configure() {
	if [ -z "$(command -v mkfontdir)" ]; then
		echo
		echo "Command 'mkfontdir' is not found."
		echo "Install it by running 'sudo apt install xfonts-utils'."
		echo
		exit 1
	fi
}

termux_step_make_install() {
	for i in {0..4}; do
		local dir="${TERMUX_PKG_SRCDIR}/${font_sources[i]//.tar.bz2}"

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
