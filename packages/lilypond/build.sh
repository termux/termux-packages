TERMUX_PKG_HOMEPAGE=https://lilypond.org/
TERMUX_PKG_DESCRIPTION="A music engraving program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE, LICENSE.OFL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.24.3"
TERMUX_PKG_SRCURL=https://lilypond.org/download/sources/v${TERMUX_PKG_VERSION%.*}/lilypond-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=df005f76ef7af5a4cd74a10f8e7115278b7fa79f14018937b65c109498ec44be
TERMUX_PKG_DEPENDS="fontconfig, freetype, ghostscript, glib, guile, harfbuzz, libc++, pango, python, tex-gyre"
TERMUX_PKG_BUILD_DEPENDS="flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-documentation
GUILE_FLAVOR=guile-3.0
PYTHON=python${TERMUX_PYTHON_VERSION}
"

termux_step_post_make_install() {
	pushd $TERMUX_PREFIX/share/lilypond
	local dst
	for dst in $(find . -type f -name "texgyre*.otf"); do
		local src="$TERMUX_PREFIX/share/fonts/tex-gyre/$(basename "$dst")"
		if [ -e "$src" ]; then
			ln -sf "$src" "$dst"
		fi
	done
	popd
}
