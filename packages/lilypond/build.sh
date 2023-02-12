TERMUX_PKG_HOMEPAGE=https://lilypond.org/
TERMUX_PKG_DESCRIPTION="A music engraving program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE, LICENSE.OFL"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.24
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://lilypond.org/download/sources/v${_MAJOR_VERSION}/lilypond-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d5c59087564a5cd6f08a52ba80e7d6509b91c585e44385dcc0fa39265d181509
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
