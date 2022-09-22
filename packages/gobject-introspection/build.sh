TERMUX_PKG_HOMEPAGE=https://gi.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Uniform machine readable API"
TERMUX_PKG_LICENSE="LGPL-2.0, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.74
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gobject-introspection/${_MAJOR_VERSION}/gobject-introspection-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=347b3a719e68ba4c69ff2d57ee2689233ea8c07fc492205e573386779e42d653
TERMUX_PKG_BUILD_DEPENDS="glib, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpython=python
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

	echo "Applying meson.diff"
	sed "s%@PYTHON_VERSION@%$_PYTHON_VERSION%g" \
		$TERMUX_PKG_BUILDER_DIR/meson.diff | patch --silent -p1

	CPPFLAGS+="
		-I$TERMUX_PREFIX/include/python${_PYTHON_VERSION}
		-I$TERMUX_PREFIX/include/python${_PYTHON_VERSION}/cpython
		"
}
