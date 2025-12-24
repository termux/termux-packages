termux_step_create_python_debscripts() {
	if [[ -n "${SUB_PKG_NAME-}" ]]; then
		local _package_name="$SUB_PKG_NAME"
		local _package_python_home="$SUB_PKG_DIR/massage$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION"
		local _package_python_deps="${TERMUX_SUBPKG_PYTHON_RUNTIME_DEPS//, / }"
	else
		local _package_name="$TERMUX_PKG_NAME"
		local _package_python_home="$TERMUX_PKG_MASSAGEDIR$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION"
		local _package_python_deps="${TERMUX_PKG_PYTHON_RUNTIME_DEPS//, / }"
	fi

	local py_file_in_lib_python="" pip_metadata_file=""

	# if the package does not contain any .py files in
	# $TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION,
	# then debpython (py3compile and py3clean) are not
	# necessary or not currently supported for this package
	if [[ -d "$_package_python_home" ]]; then
		py_file_in_lib_python="$(find "$_package_python_home" -name "*.py" -print -quit)"
	fi

	# metadata file that at least some packages have, which contains the 'pip'-facing name of the
	# package and any PyPi dependencies it has.
	if [[ -d "$_package_python_home/site-packages" ]]; then
		pip_metadata_file="$(find "$_package_python_home/site-packages" -name "METADATA" -print -quit)"
	fi

	# add the internal 'pip'-facing name of the package to the 'pip install' dependencies if it exists
	# in the 'METADATA' file and the 'METADATA' file also marks the package as depending
	# on any other 'pip'-facing packages, which will install all the 'pip'-facing dependencies
	# the software marks itself as depending on from PyPi that are not already installed from other Termux packages.
	# if more than one 'METADATA' file is detected, this condition will evaluate false so nothing will happen.
	if [[ -f "$pip_metadata_file" ]] && grep -q '^Requires-Dist' "$pip_metadata_file"; then
		local package_pip_name="$(grep 'Name:' "$pip_metadata_file" | cut -d' ' -f2)"
		_package_python_deps+=" $package_pip_name"
	fi

	# if there are no .py files in $TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/,
	# and the package has an empty $_package_python_deps, then this function does not need to do anything
	if [[ -z "$py_file_in_lib_python" ]] && [[ -z "${_package_python_deps}" ]]; then
		return
	fi

	# if a postinst script does not already exist, create a new one
	# but if the postinst script already exists and has 'exit 0'
	# as its last line, remove that line so that it does not
	# prevent execution of the additional commands
	if [[ ! -f postinst ]]; then
		echo "#!${TERMUX_PREFIX_CLASSICAL}/bin/sh" >postinst
		chmod 0755 postinst
	elif tail -n1 postinst | grep -q 'exit 0'; then
		sed -i '$d' postinst
	fi

	# if the package format is .deb, only run the script
	# if the package is being configured (not failed)
	if [[ "$TERMUX_PACKAGE_FORMAT" == "debian" ]]; then
		cat <<-POSTINST_EOF >>postinst
			if [ "\$1" != "configure" ]; then
				exit 0
			fi
		POSTINST_EOF
	fi

	# if the package has runtime dependencies requiring pip,
	# make this script install them
	if [[ -n "${_package_python_deps}" ]]; then
		local pip_package_name="python-pip" upgrade_flag="--upgrade"

		if [[ "$TERMUX_PACKAGE_LIBRARY" == "glibc" ]]; then
			pip_package_name+="-glibc"
		fi

		# if the list of dependencies to install from PyPi has the name of
		# the current package with any 'python-' prefix stripped from it anywhere in it,
		# do not use the '--upgrade' argument to pip, in order to avoid overwriting
		# the non-PyPi local package files with a different software with the same name,
		# or the same package of an incorrect version, from PyPi.
		# this is particularly important for the 'nala' package, for example.
		if [[ " $(tr ' ' '\n' <<<"${_package_python_deps}" | sed "s/'//g; s/</ /g; s/>/ /g; s/=/ /g" | awk '{printf $1 " "}')" =~ " ${_package_name//python-/} " ]]; then
			upgrade_flag=""
		fi

		cat <<-POSTINST_EOF >>postinst
			echo "Installing dependencies for ${_package_name} through pip..."
			LD_PRELOAD='' LDFLAGS="-lpython$TERMUX_PYTHON_VERSION" MATHLIB="m" "${TERMUX_PREFIX}/bin/pip3" install ${upgrade_flag} ${_package_python_deps}
		POSTINST_EOF

		# ensure that pip is added as a dependency to all
		# packages that run the 'pip' command during installation.
		if ([[ "$TERMUX_PACKAGE_FORMAT" == "debian" ]] && ! grep -q -E "Depends.*$pip_package_name(,|$)" control) || ([[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]] && ! grep -q "depend = $pip_package_name" .PKGINFO); then
			termux_error_exit "'$_package_name' must depend on '$pip_package_name' because it needs to run 'pip' during installation!"
		fi
	fi

	# if the package does not contain any .py files in
	# $TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION,
	# then this function does not need to do anything else
	if [[ -z "$py_file_in_lib_python" ]]; then
		return
	fi

	# post-inst script to generate *.pyc files
	cat <<-POSTINST_EOF >>postinst
		if [ -f "${TERMUX_PREFIX}/bin/py3compile" ]; then
			LD_PRELOAD='' "${TERMUX_PREFIX}/bin/py3compile" -p "$_package_name" "${TERMUX_PREFIX}/lib/python${TERMUX_PYTHON_VERSION}/"
		fi
	POSTINST_EOF

	# make the last command of the postinst script 'exit 0'
	# because if the previous last command was a condition,
	# and the condition failed, then the postinst script could
	# fail, which would not actually be the desired result
	cat <<-POSTINST_EOF >>postinst
		exit 0
	POSTINST_EOF

	# if a prerm script does not already exist, create a new one
	# but if the prerm script already exists and has 'exit 0'
	# as its last line, remove that line so that it does not
	# prevent execution of the additional commands
	if [[ ! -f prerm ]]; then
		echo "#!${TERMUX_PREFIX_CLASSICAL}/bin/sh" >prerm
		chmod 0755 prerm
	elif tail -n1 prerm | grep -q 'exit 0'; then
		sed -i '$d' prerm
	fi

	# if the package format is .deb, only run the script
	# if the package is being removed (not failed)
	if [[ "$TERMUX_PACKAGE_FORMAT" == "debian" ]]; then
		cat <<-PRERM_EOF >>prerm
			if [ "\$1" != "remove" ]; then
				exit 0
			fi
		PRERM_EOF
	fi

	# pre-rm script to cleanup runtime-generated files.
	cat <<-PRERM_EOF >>prerm
		if [ -f "${TERMUX_PREFIX}/bin/py3clean" ]; then
			LD_PRELOAD='' "${TERMUX_PREFIX}/bin/py3clean" -p "$_package_name"
		fi
	PRERM_EOF

	# make the last command of the prerm script 'exit 0'
	# because if the previous last command was a condition,
	# and the condition failed, then the prerm script could
	# fail, which would not actually be the desired result
	cat <<-PRERM_EOF >>prerm
		exit 0
	PRERM_EOF

	# running py3compile in a package for pacman during a package update
	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]] && ! grep -qs 'post_install' postupg; then
		echo "post_install" >>postupg
	fi
}
