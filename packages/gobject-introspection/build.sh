TERMUX_PKG_HOMEPAGE=https://gi.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Uniform machine readable API"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.68.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/GNOME/gobject-introspection/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=13595a257df7d0b71b002ec115f1faafd3295c9516f307e2c57bd219d5cd8369
TERMUX_PKG_BUILD_DEPENDS="glib, python"

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dpython=python${_PYTHON_VERSION}"
	echo "Applying meson.diff"
	sed "s%@PYTHON_VERSION@%$_PYTHON_VERSION%g" \
		$TERMUX_PKG_BUILDER_DIR/meson.diff | patch --silent -p1

	CPPFLAGS+=" -I$TERMUX_PREFIX/include/python${_PYTHON_VERSION} -I$TERMUX_PREFIX/include/python${_PYTHON_VERSION}/cpython"
}

termux_step_post_make_install() {
	soabi=cpython-${_PYTHON_VERSION//.}

	cd $TERMUX_PREFIX/lib/gobject-introspection/giscanner
	m=_giscanner
	for s in $m.$soabi-*.so; do
		if [ -f $s ]; then
			mv $s $m.$soabi.so
		fi
	done
}
