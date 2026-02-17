TERMUX_PKG_HOMEPAGE=https://codeberg.org/ravachol/kew
TERMUX_PKG_DESCRIPTION="Music for the Shell"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.7.3"
TERMUX_PKG_SRCURL="https://codeberg.org/ravachol/kew/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7ed1f2bb7bcff9da33cfbd1cddb6ddf9273b3ec0a53f565c4532d95efe0e6b26
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="chafa, faad2, fftw, glib, libogg, libvorbis, libopus, opusfile, taglib"

termux_step_post_get_source() {
	local original_prefix_component_one="/data/data/com."
	local original_prefix_component_two="termux/files/usr"
	local original_prefix="${original_prefix_component_one}${original_prefix_component_two}"
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i -e "s%${original_prefix}%\@HARDCODED_TERMUX_PREFIX\@%g"
}

termux_step_pre_configure() {
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		export DEBUG=1
	fi
}
