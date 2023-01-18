termux_step_get_dependencies_python() {
	if [ "$TERMUX_PKG_SETUP_PYTHON" = "true" ]; then
		# python pip setup
		termux_setup_python_pip

		# installing python modules
		LDFLAGS+=" -Wl,--as-needed,-lpython${TERMUX_PYTHON_VERSION}"
		if [ "$TERMUX_SKIP_DEPCHECK" = "false" ]; then
			local pip
			local pip_pkgs="$TERMUX_PKG_PYTHON_COMMON_DEPS, "
			if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
				pip="pip3"
				pip_pkgs+="$TERMUX_PKG_PYTHON_TARGET_DEPS"
			else
				pip="build-pip"
				pip_pkgs+="$TERMUX_PKG_PYTHON_BUILD_DEPS"
			fi
			for i in ${pip_pkgs//, / } ; do
				local name_python_module=$(echo "$i" | sed "s/<=/ /; s/>=/ /; s/</ /; s/>/ /; s/'//g" | awk '{printf $1}')
				local name_python_module_termux=$(echo "$name_python_module" | grep 'python-' || echo "python-$name_python_module")
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Installing the dependency python module $i if necessary..."
				if $pip show "$name_python_module" &>/dev/null && ([ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "false" ] || termux_check_package_in_built_packages_list "$name_python_module_termux"); then
					[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Skipping the already installed dependency python module $i"
					continue
				fi
				bash -c "$pip install "$(test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true" && echo "-I" || true)" $i"
				[ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && termux_add_package_to_built_packages_list "$name_python_module_termux"
			done
		fi

		# adding and setting values ​​to work properly with python modules
		export PYTHONPATH=$TERMUX_PYTHON_HOME/site-packages
		export PYTHON_SITE_PKG=$PYTHONPATH
	fi
}
