TERMUX_PKG_HOMEPAGE=https://dejavu-fonts.github.io/
TERMUX_PKG_DESCRIPTION="Font family based on the Bitstream Vera Fonts with a wider range of characters"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.37
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dejavu/dejavu/${TERMUX_PKG_VERSION}/dejavu-fonts-ttf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=fa9ca4d13871dd122f61258a80d01751d603b4d3ee14095d65453b4e846e17d7
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="
etc/fonts/conf.d/20-unhint-small-dejavu-sans-mono.conf
etc/fonts/conf.d/20-unhint-small-dejavu-sans.conf
etc/fonts/conf.d/20-unhint-small-dejavu-serif.conf
etc/fonts/conf.d/57-dejavu-sans-mono.conf
etc/fonts/conf.d/57-dejavu-sans.conf
etc/fonts/conf.d/57-dejavu-serif.conf
"

termux_step_make_install() {
	## Install fonts.
	mkdir -p "${TERMUX_PREFIX}/share/fonts/TTF"
	cp -f ttf/*.ttf "${TERMUX_PREFIX}/share/fonts/TTF/"

	## Install config files used by 'fontconfig' package.
	mkdir -p "${TERMUX_PREFIX}/etc/fonts/conf.d"
	cp -f fontconfig/*.conf "${TERMUX_PREFIX}/etc/fonts/conf.d/"
}
