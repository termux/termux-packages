TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org font encoding files"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.7
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/font/encodings-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3a39a9f43b16521cdbd9f810090952af4f109b44fa7a865cd555f8febcea70a4
TERMUX_PKG_PLATFORM_INDEPENDENT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-fontrootdir=$TERMUX_PREFIX/share/fonts"

termux_step_pre_configure() {
	## Checking only for mkfontdir which is a part of xfonts-utils that provides
	## tool mkfontscale used in further steps.
	if [ -z "$(command -v mkfontdir)" ]; then
		echo
		echo "Command 'mkfontdir' is not found."
		echo "Install it by running 'sudo apt install xfonts-utils'."
		echo
		exit 1
	fi
}

termux_step_post_make_install() {
	cd "${TERMUX_PREFIX}"/share/fonts/encodings/large
	mkfontscale -b -s -l -n -r -p "${TERMUX_PREFIX}"/share/fonts/encodings/large -e . .

	cd "${TERMUX_PREFIX}"/share/fonts/encodings/
	mkfontscale -b -s -l -n -r -p "${TERMUX_PREFIX}"/share/fonts/encodings -e . -e large .
}
