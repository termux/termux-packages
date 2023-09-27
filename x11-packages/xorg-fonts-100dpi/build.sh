TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org 100dpi fonts"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.4
_FONT_ADOBE_UTOPIA_VERSION=${TERMUX_PKG_VERSION%.*}.$((${TERMUX_PKG_VERSION##*.}+1))
TERMUX_PKG_SRCURL=(https://xorg.freedesktop.org/releases/individual/font/font-adobe-100dpi-${TERMUX_PKG_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-adobe-utopia-100dpi-${_FONT_ADOBE_UTOPIA_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-bh-100dpi-${TERMUX_PKG_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-bh-lucidatypewriter-100dpi-${TERMUX_PKG_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-bitstream-100dpi-${TERMUX_PKG_VERSION}.tar.xz)
TERMUX_PKG_SHA256=(b67aff445e056328d53f9732d39884f55dd8d303fc25af3dbba33a8ba35a9ccf
                   fb84ec297a906973548ca59b7c6daeaad21244bec5d3fb1e7c93df5ef43b024b
                   fd8f5efe8491faabdd2744808d3d4eafdae5c83e617017c7fddd2716d049ab1e
                   76ec09eda4094a29d47b91cf59c3eba229c8f7d1ca6bae2abbb3f925e33de8f2
                   2d1cc682efe4f7ebdf5fbd88961d8ca32b2729968728633dea20a1627690c1a7)
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
		local dir="${TERMUX_PKG_SRCDIR}/${file%%.tar.*}"

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

termux_step_post_massage() {
	rm -f share/fonts/100dpi/fonts.*
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/COPYING
}
