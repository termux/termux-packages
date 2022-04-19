TERMUX_SUBPKG_DESCRIPTION="Python bindings for Frida"
TERMUX_SUBPKG_INCLUDE="lib/python*"

termux_step_create_subpkg_debscripts() {
        _PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip${_PYTHON_VERSION} install wcwidth colorama pygments" >> postinst
}
