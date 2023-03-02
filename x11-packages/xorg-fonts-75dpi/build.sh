TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org 75dpi fonts"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.4
_FONT_ADOBE_UTOPIA_VERSION=${TERMUX_PKG_VERSION%.*}.$((${TERMUX_PKG_VERSION##*.}+1))
TERMUX_PKG_SRCURL=(https://xorg.freedesktop.org/releases/individual/font/font-adobe-75dpi-${TERMUX_PKG_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-adobe-utopia-75dpi-${_FONT_ADOBE_UTOPIA_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-bh-75dpi-${TERMUX_PKG_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-bh-lucidatypewriter-75dpi-${TERMUX_PKG_VERSION}.tar.xz
                   https://xorg.freedesktop.org/releases/individual/font/font-bitstream-75dpi-${TERMUX_PKG_VERSION}.tar.xz)
TERMUX_PKG_SHA256=(1281a62dbeded169e495cae1a5b487e1f336f2b4d971d92911c59c103999b911
                   a726245932d0724fa0c538c992811d63d597e5f53928f4048e9caf5623797760
                   6026d8c073563dd3cbb4878d0076eed970debabd21423b3b61dd90441b9e7cda
                   864e2c39ac61f04f693fc2c8aaaed24b298c2cd40283cec12eee459c5635e8f5
                   aaeb34d87424a9c2b0cf0e8590704c90cb5b42c6a3b6a0ef9e4676ef773bf826)
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
			--with-fontdir="${TERMUX_PREFIX}/share/fonts/75dpi"
		make -j "${TERMUX_MAKE_PROCESSES}"
		make install
		popd
	done
}

termux_step_post_massage() {
	rm -f share/fonts/75dpi/fonts.*
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/COPYING
}
