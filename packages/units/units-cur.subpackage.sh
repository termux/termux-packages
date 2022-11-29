TERMUX_SUBPKG_DESCRIPTION="units_cur Python script"
TERMUX_SUBPKG_INCLUDE="
bin/units_cur
"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_DEPENDS="python"
TERMUX_SUBPKG_BREAKS="units (<< 2.22)"
TERMUX_SUBPKG_REPLACES="units (<< 2.22)"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install requests
	EOF
}
