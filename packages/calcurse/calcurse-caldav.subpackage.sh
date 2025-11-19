TERMUX_SUBPKG_INCLUDE="bin/calcurse-caldav"
TERMUX_SUBPKG_DESCRIPTION="Sync calcurse with remote caldav calendar"
TERMUX_SUBPKG_DEPENDS="python, python-pip"
TERMUX_SUBPKG_REPLACES="calcurse (<< 4.7.1-1)"
TERMUX_SUBPKG_BREAKS="calcurse (<< 4.7.1-1)"

termux_step_create_subpkg_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3 install httplib2" >> postinst
}
