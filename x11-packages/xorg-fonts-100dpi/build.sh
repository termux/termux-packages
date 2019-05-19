TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org 100dpi fonts"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=4
TERMUX_PKG_DEPENDS="fontconfig-utils, xorg-font-util, xorg-fonts-alias, xorg-fonts-encodings, xorg-mkfontscale"
TERMUX_PKG_CONFLICTS="xorg-fonts-lite"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

font_sources=("font-adobe-100dpi-1.0.3.tar.bz2"
              "font-adobe-utopia-100dpi-1.0.4.tar.bz2"
              "font-bh-100dpi-1.0.3.tar.bz2"
              "font-bh-lucidatypewriter-100dpi-1.0.3.tar.bz2"
              "font-bitstream-100dpi-1.0.3.tar.bz2")

font_sources_sha256=("b2c08433eab5cb202470aa9f779efefce8d9cab2534f34f3aa4a31d05671c054"
                     "d16f5e3f227cc6dd07a160a71f443559682dbc35f1c056a5385085aaec4fada5"
                     "23c07162708e4b79eb33095c8bfa62c783717a9431254bbf44863734ea239481"
                     "62a83363c2536095fda49d260d21e0847675676e4e3415054064cbdffa641fbb"
                     "ebe0d7444e3d7c8da7642055ac2206f0190ee060700d99cd876f8fc9964cb6ce")

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
			--with-fontdir="${TERMUX_PREFIX}/share/fonts/100dpi"
		make -j "${TERMUX_MAKE_PROCESSES}"
		make install
		popd
	done
}

termux_step_post_make_install() {
	rm -f "${TERMUX_PREFIX}"/share/fonts/100dpi/fonts.*
}
