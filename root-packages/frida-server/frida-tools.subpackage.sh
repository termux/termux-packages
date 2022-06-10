TERMUX_SUBPKG_DESCRIPTION="CLI tools for Frida"
TERMUX_SUBPKG_DEPENDS="frida-python"
TERMUX_SUBPKG_INCLUDE="
bin/frida
bin/frida-apk
bin/frida-create
bin/frida-discover
bin/frida-join
bin/frida-kill
bin/frida-ls-devices
bin/frida-portal
bin/frida-ps
bin/frida-trace
bin/gum-graft
"

termux_step_create_subpkg_debscripts() {
        _PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip${_PYTHON_VERSION} install prompt_toolkit colorama pygments" >> postinst
}
