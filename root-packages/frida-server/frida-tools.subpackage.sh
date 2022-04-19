TERMUX_SUBPKG_DESCRIPTION="CLI tools for Frida"
TERMUX_SUBPKG_DEPENDS="frida-python"
TERMUX_SUBPKG_INCLUDE="
bin/frida-discover
bin/frida
bin/frida-kill
bin/frida-ls-devices
bin/frida-ps
bin/frida-trace
"

termux_step_create_subpkg_debscripts() {
        _PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip${_PYTHON_VERSION} install prompt_toolkit colorama pygments" >> postinst
}
