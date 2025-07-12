termux_step_create_python_debscripts() {
	if [ -n "${SUB_PKG_NAME-}" ]; then
		local _package_name="$SUB_PKG_NAME"
		local _package_massagedir="$SUB_PKG_DIR/massage/$TERMUX_PREFIX"
	else
		local _package_name="$TERMUX_PKG_NAME"
		local _package_massagedir="$TERMUX_PKG_MASSAGEDIR$TERMUX_PREFIX"
	fi

	# if the package does not contain any .py files in
	# $TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION,
	# then debpython (py3compile and py3clean) are not
	# necessary or not currently supported for this package
	local contains_py_files_in_lib_python=false

	if [ -d "$_package_massagedir/lib/python$TERMUX_PYTHON_VERSION/" ]; then
		local py_file_in_lib_python="$(find \
			"$_package_massagedir/lib/python$TERMUX_PYTHON_VERSION/" \
			-name "*.py" -print -quit)"
		if [ -n "$py_file_in_lib_python" ]; then
			contains_py_files_in_lib_python=true
		fi
	fi

	# if there are no .py files in $TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/,
	# and the package either is a subpackage or has an empty $TERMUX_PKG_PYTHON_TARGET_DEPS,
	# then this function does not need to do anything
	if [ "$contains_py_files_in_lib_python" = "false" ]; then
		if [[ -n "${SUB_PKG_NAME-}" || -z "${TERMUX_PKG_PYTHON_TARGET_DEPS}" ]]; then
			return
		fi
	fi

	# if a postinst script does not already exist, create a new one
	# but if the postinst script already exists and has 'exit 0'
	# as its last line, remove that line so that it does not
	# prevent execution of the additional commands
	if [ ! -f postinst ]; then
		echo "#!${TERMUX_PREFIX_CLASSICAL}/bin/sh" > postinst
		chmod 0755 postinst
	elif tail -n1 postinst | grep -q 'exit 0'; then
		sed -i '$d' postinst
	fi

	# if the package format is .deb, only run the script
	# if the package is being configured (not failed)
	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
		cat <<- POSTINST_EOF >> postinst
		if [ "\$1" != "configure" ]; then
			exit 0
		fi
		POSTINST_EOF
	fi

	# if the package has runtime dependencies requiring pip,
	# make this script install them there is not currently
	# any such thing as $TERMUX_SUBPKG_PYTHON_TARGET_DEPS.
	# so skip this for subpackages at this time
	# (those cases remain manually created per-subpackage)
	if [[ -z "${SUB_PKG_NAME-}" && -n "${TERMUX_PKG_PYTHON_TARGET_DEPS}" ]]; then
		cat <<- POSTINST_EOF >> postinst
		echo "Installing dependencies for ${_package_name} through pip..."
		LD_PRELOAD='' "${TERMUX_PREFIX}/bin/pip3" install --upgrade ${TERMUX_PKG_PYTHON_TARGET_DEPS//,/}
		POSTINST_EOF
	fi

	# if the package does not contain any .py files in
	# $TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION,
	# then this function does not need to do anything else
	if [ "$contains_py_files_in_lib_python" = "false" ]; then
		return
	fi

	# post-inst script to generate *.pyc files
	cat <<- POSTINST_EOF >> postinst
	if [ -f "${TERMUX_PREFIX}/bin/py3compile" ]; then
		LD_PRELOAD='' "${TERMUX_PREFIX}/bin/py3compile" -p "$_package_name" "${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/"
	fi
	POSTINST_EOF

	# if a prerm script does not already exist, create a new one
	# but if the prerm script already exists and has 'exit 0'
	# as its last line, remove that line so that it does not
	# prevent execution of the additional commands
	if [ ! -f prerm ]; then
		echo "#!${TERMUX_PREFIX_CLASSICAL}/bin/sh" > prerm
		chmod 0755 prerm
	elif tail -n1 prerm | grep -q 'exit 0'; then
		sed -i '$d' prerm
	fi

	# if the package format is .deb, only run the script
	# if the package is being removed (not failed)
	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
		cat <<- PRERM_EOF >> prerm
		if [ "\$1" != "remove" ]; then
			exit 0
		fi
		PRERM_EOF
	fi

	# pre-rm script to cleanup runtime-generated files.
	cat <<- PRERM_EOF >> prerm
	if [ -f "${TERMUX_PREFIX}/bin/py3clean" ]; then
		LD_PRELOAD='' "${TERMUX_PREFIX}/bin/py3clean" -p "$_package_name"
	fi
	PRERM_EOF

	# running py3compile in a package for pacman during a package update
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] && ! grep -qs 'post_install' postupg; then
		echo "post_install" >> postupg
	fi
}
