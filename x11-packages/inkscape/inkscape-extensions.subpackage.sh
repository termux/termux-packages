TERMUX_SUBPKG_INCLUDE="share/inkscape/extensions"
TERMUX_SUBPKG_DESCRIPTION="Inkscape extensions"
TERMUX_SUBPKG_DEPENDS="python, python-numpy, python-pip"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Installing dependencies through pip..."
	pip3 install lxml scour
	EOF
}
