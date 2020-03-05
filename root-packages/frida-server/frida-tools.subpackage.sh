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
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3.8 install prompt_toolkit colorama pygments" >> postinst
}
