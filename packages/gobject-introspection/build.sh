TERMUX_PKG_HOMEPAGE=https://gi.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Uniform machine readable API"
TERMUX_PKG_LICENSE="LGPL-2.0, GPL-2.0"
TERMUX_PKG_VERSION=1.72.0
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/GNOME/gobject-introspection/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=07c30d7f465dabd861c03a950430343e976d445179ad451a4dd1b17329e1cbae
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
