TERMUX_PKG_HOMEPAGE=https://dbus.freedesktop.org/doc/dbus-python/
TERMUX_PKG_DESCRIPTION="Python bindings for D-Bus"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dbus.freedesktop.org/releases/dbus-python/dbus-python-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad67819308618b5069537be237f8e68ca1c7fcc95ee4a121fe6845b1418248f8
TERMUX_PKG_DEPENDS="dbus, glib, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpython=python
"

termux_step_pre_configure() {
	# Force using Meson
	rm -f configure

	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)

	termux_setup_python_crossenv
	pushd $TERMUX_PYTHON_CROSSENV_SRCDIR
	_CROSSENV_PREFIX=$TERMUX_PKG_BUILDDIR/python-crossenv-prefix
	python${_PYTHON_VERSION} -m crossenv \
		$TERMUX_PREFIX/bin/python${_PYTHON_VERSION} \
		${_CROSSENV_PREFIX}
	popd
	. ${_CROSSENV_PREFIX}/bin/activate

	LDFLAGS+=" -lpython${_PYTHON_VERSION}"
}
