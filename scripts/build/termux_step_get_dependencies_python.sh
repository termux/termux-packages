termux_step_get_dependencies_python() {
	if [ "$TERMUX_PKG_SETUP_PYTHON" = "true" ]; then
		# python pip setup
		termux_setup_python_pip

		# installing python modules
		LDFLAGS+=" -Wl,--as-needed,-lpython${TERMUX_PYTHON_VERSION}"
		local pip
		local pip_pkgs="$TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS, "
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			pip="pip3"
			pip_pkgs+="$TERMUX_PKG_PYTHON_TARGET_DEPS"
		else
			pip="build-pip"
			pip_pkgs+="$TERMUX_PKG_PYTHON_CROSS_BUILD_DEPS"
		fi
		for i in ${pip_pkgs//, / } ; do
			local name_python_module=$(sed "s/<=/ /; s/>=/ /; s/</ /; s/>/ /; s/'//g" <<< "$i" | awk '{printf $1}')
			local name_python_module_termux=$(grep 'python-' <<< "$name_python_module" || echo "python-$name_python_module")
			[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Installing the dependency python module $i if necessary..."
			if $pip show "$i" &>/dev/null && ([ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "false" ] || termux_check_package_in_built_packages_list "$name_python_module_termux"); then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Skipping the already installed dependency python module $i"
				continue
			fi
			bash -c "$pip install "$(test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true" && echo "-I" || true)" $i"
			[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && termux_add_package_to_built_packages_list "$name_python_module_termux"
		done

		# adding and setting values ​​to work properly with python modules
		export PYTHONPATH="${TERMUX_PYTHON_CROSSENV_BUILDHOME}:${TERMUX_PYTHON_HOME}/site-packages"
		if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
			export TERMUX_PYTHON_MAINPATH="${PYTHONPATH}:${TERMUX_PYTHON_CROSSENV_BUILDHOME}/site-packages"
		fi
		export PYTHON_SITE_PKG=$PYTHONPATH
	fi
}
