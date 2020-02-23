TERMUX_SUBPKG_DESCRIPTION="Python bindings for Frida"
TERMUX_SUBPKG_INCLUDE="lib/python*"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3.8 install wcwidth colorama pygments" >> postinst
}
