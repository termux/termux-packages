TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org font encoding files"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_REVISION=21
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/font/encodings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=bd96e16143a044b19e87f217cf6a3763a70c561d1076aad6f6d862ec41774a31
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
