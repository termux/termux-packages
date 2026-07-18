TERMUX_PKG_HOMEPAGE=https://kewplayer.com
TERMUX_PKG_DESCRIPTION="Music for the Shell"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.6"
TERMUX_PKG_SRCURL="https://codeberg.org/ravachol/kew/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=42eff21d7af6d65e4e0dbb5a8671a46ca3a4393b88688b068e3b11d73368c3c2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="chafa, faad2, fftw, glib, libogg, libvorbis, libopus, opusfile, taglib"
TERMUX_PKG_SUGGESTS="chroma-visualizer"
TERMUX_PKG_EXTRA_MAKE_ARGS="ARCH=$TERMUX_ARCH"

termux_step_post_get_source() {
	local original_prefix_component_one="/data/data/com."
	local original_prefix_component_two="termux/files/usr"
	local original_prefix="${original_prefix_component_one}${original_prefix_component_two}"
	find "$TERMUX_PKG_SRCDIR" -type f -print0 | \
		xargs -0 sed -i -e "s%${original_prefix}%\@HARDCODED_TERMUX_PREFIX\@%g"
}

termux_step_pre_configure() {
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		TERMUX_PKG_EXTRA_MAKE_ARGS+=" DEBUG=1"
	fi
}
