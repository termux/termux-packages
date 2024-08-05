TERMUX_PKG_HOMEPAGE=https://lilypond.org/
TERMUX_PKG_DESCRIPTION="A music engraving program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE, LICENSE.OFL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.24.4"
TERMUX_PKG_SRCURL=https://lilypond.org/download/sources/v${TERMUX_PKG_VERSION%.*}/lilypond-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e96fa03571c79f20e1979653afabdbe4ee42765a3d9fd14953f0cd9eea51781c
TERMUX_PKG_AUTO_UPDATE=true
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
