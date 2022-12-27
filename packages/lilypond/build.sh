TERMUX_PKG_HOMEPAGE=https://lilypond.org/
TERMUX_PKG_DESCRIPTION="A music engraving program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING, LICENSE, LICENSE.OFL"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.24
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://lilypond.org/download/sources/v${_MAJOR_VERSION}/lilypond-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3cedbe3b92b02569e3a6f2f0674858967b3da278d70aa3e98aef5bdcd7f78b69
TERMUX_PKG_DEPENDS="fontconfig, freetype, ghostscript, glib, guile, harfbuzz, libc++, pango, python, tex-gyre"
TERMUX_PKG_BUILD_DEPENDS="flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-documentation
--with-texgyre-dir=$TERMUX_PREFIX/share/fonts/tex-gyre
--with-urwotf-dir=/dev/null
GUILE_FLAVOR=guile-3.0
"

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate
	build-pip install wheel
}

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
