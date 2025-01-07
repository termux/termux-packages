TERMUX_SUBPKG_DESCRIPTION="Test files for PyPy"
TERMUX_SUBPKG_INCLUDE="
opt/pypy/lib-python/${_MAJOR_VERSION}/test
opt/pypy/lib-python/${_MAJOR_VERSION}/*/test
opt/pypy/lib-python/${_MAJOR_VERSION}/*/tests
"

termux_step_create_subpkg_debscripts() {
	# Pre-rm script to cleanup runtime-generated files.
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh

	if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then
	    exit 0
	fi

	echo "Deleting *.pyc..."
	find $TERMUX_PREFIX/opt/pypy/lib-python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

	exit 0
	PRERM_EOF

	chmod 0755 prerm
}
