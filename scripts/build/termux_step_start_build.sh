termux_step_start_build() {
	# shellcheck source=/dev/null
	source "$TERMUX_PKG_BUILDER_SCRIPT"

	if [ -n "$TERMUX_VIRTUAL_PKG_SRC" ]; then
		export TERMUX_VIRTUAL_PKG=true
	fi
	if [ "$TERMUX_VIRTUAL_PKG" = "true" ]; then
		if [ -z "${TERMUX_PKG_VERSION:=}" ]; then
			TERMUX_PKG_VERSION="0"
		fi
		if [ -n "$TERMUX_VIRTUAL_PKG_SRC" ]; then
			# Parsing the original package
			termux_get_pkg_builder_dir_and_pkg_builder_script "$TERMUX_VIRTUAL_PKG_SRC"
			# Checking that the original package is not a virtual package
			(
				local TERMUX_VIRTUAL_PKG_SRC_ORG="$TERMUX_VIRTUAL_PKG_SRC"
				TERMUX_VIRTUAL_PKG=false
				TERMUX_VIRTUAL_PKG_SRC=""
				source "$TERMUX_PKG_BUILDER_SCRIPT"
				if [ "$TERMUX_VIRTUAL_PKG" = "true" ] || [ -n "$TERMUX_VIRTUAL_PKG_SRC" ]; then
					termux_error_exit "Virtual package '${TERMUX_VIRTUAL_PKG_NAME}' specifies virtual package '${TERMUX_VIRTUAL_PKG_SRC_ORG}' as source package. Cannot use virtual package as source."
				fi
			)
			# Mixing the original package with the virtual package
			source "$TERMUX_PKG_BUILDER_SCRIPT"
			source "$TERMUX_VIRTUAL_PKG_BUILDER_SCRIPT"
			# Setting the source in the virtual package
			termux_step_setup_virtual_srcs
			# Restoring variables by virtual package
			termux_restore_variables_by_virtual_pkg
		fi
	fi

	# Path to hostbuild marker, for use if package has hostbuild step
	TERMUX_HOSTBUILD_MARKER="$TERMUX_PKG_HOSTBUILD_DIR/TERMUX_BUILT_FOR_$TERMUX_PKG_VERSION"

	if [ "$TERMUX_PKG_METAPACKAGE" = "true" ]; then
		# Metapackage has no sources and therefore platform-independent.
		TERMUX_PKG_SKIP_SRC_EXTRACT=true
		TERMUX_PKG_PLATFORM_INDEPENDENT=true
	fi

	if [ -n "${TERMUX_PKG_BLACKLISTED_ARCHES:=""}" ] && [ "$TERMUX_PKG_BLACKLISTED_ARCHES" != "${TERMUX_PKG_BLACKLISTED_ARCHES/$TERMUX_ARCH/}" ]; then
		echo "Skipping building $TERMUX_PKG_NAME for arch $TERMUX_ARCH"
		exit 0
	fi

	if [ -n "$TERMUX_PKG_PYTHON_COMMON_DEPS" ] || [[ "$TERMUX_ON_DEVICE_BUILD" = "false" && -n "$TERMUX_PKG_PYTHON_BUILD_DEPS" ]] || [[ "$TERMUX_ON_DEVICE_BUILD" = "true" && -n "$TERMUX_PKG_PYTHON_TARGET_DEPS" ]]; then
		# Enable python setting
		TERMUX_PKG_SETUP_PYTHON=true
	fi

	TERMUX_PKG_FULLVERSION=$TERMUX_PKG_VERSION
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_FULLVERSION" != "${TERMUX_PKG_FULLVERSION/-/}" ]; then
		# "0" is the default revision, so only include it if the upstream versions contains "-" itself
		TERMUX_PKG_FULLVERSION+="-$TERMUX_PKG_REVISION"
	fi
	# full format version for pacman
	local TERMUX_PKG_VERSION_EDITED=${TERMUX_PKG_VERSION//-/.}
	local INCORRECT_SYMBOLS=$(echo $TERMUX_PKG_VERSION_EDITED | grep -o '[0-9][a-z]')
	if [ -n "$INCORRECT_SYMBOLS" ]; then
		local TERMUX_PKG_VERSION_EDITED=${TERMUX_PKG_VERSION_EDITED//${INCORRECT_SYMBOLS:0:1}${INCORRECT_SYMBOLS:1:1}/${INCORRECT_SYMBOLS:0:1}.${INCORRECT_SYMBOLS:1:1}}
	fi
	TERMUX_PKG_FULLVERSION_FOR_PACMAN="${TERMUX_PKG_VERSION_EDITED}"
	if [ -n "$TERMUX_PKG_REVISION" ]; then
		TERMUX_PKG_FULLVERSION_FOR_PACMAN+="-${TERMUX_PKG_REVISION}"
	else
		TERMUX_PKG_FULLVERSION_FOR_PACMAN+="-0"
	fi

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		if [ "$TERMUX_PKG_HAS_DEBUG" = "true" ]; then
			DEBUG="-dbg"
		else
			echo "Skipping building debug build for $TERMUX_PKG_NAME"
			exit 0
		fi
	else
		DEBUG=""
	fi

	if [ "$TERMUX_DEBUG_BUILD" = "false" ] && [ "$TERMUX_FORCE_BUILD" = "false" ]; then
		if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME" ] &&
			[ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME")" = "$TERMUX_PKG_FULLVERSION" ]; then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION built - skipping (rm $TERMUX_BUILT_PACKAGES_DIRECTORY/$TERMUX_PKG_NAME to force rebuild)"
			exit 0
		elif [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] &&
			([[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status} ${Version}\n' "$TERMUX_PKG_NAME" 2>/dev/null)" = "installed $TERMUX_PKG_FULLVERSION" ]] ||
			 [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && "$(pacman -Q $TERMUX_PKG_NAME 2>/dev/null)" = "$TERMUX_PKG_NAME $TERMUX_PKG_FULLVERSION_FOR_PACMAN" ]]); then
			echo "$TERMUX_PKG_NAME@$TERMUX_PKG_FULLVERSION installed - skipping"
			exit 0
		fi
	fi

	echo "termux - building $(test "${TERMUX_VIRTUAL_PKG}" = "true" && echo "virtual") $TERMUX_PKG_NAME for arch $TERMUX_ARCH..."
	test -t 1 && printf "\033]0;%s...\007" "$TERMUX_PKG_NAME"

	# Avoid exporting PKG_CONFIG_LIBDIR until after termux_step_host_build.
	export TERMUX_PKG_CONFIG_LIBDIR=$TERMUX_PREFIX/lib/pkgconfig:$TERMUX_PREFIX/share/pkgconfig

	if [ "$TERMUX_PKG_BUILD_IN_SRC" = "true" ]; then
		echo "Building in src due to TERMUX_PKG_BUILD_IN_SRC being set to true" > "$TERMUX_PKG_BUILDDIR/BUILDING_IN_SRC.txt"
		TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	fi

	if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
		# If the package has a hostbuild step, verify that it has been built
		if [ "$TERMUX_PKG_HOSTBUILD" == "true" ] && [ ! -f "$TERMUX_HOSTBUILD_MARKER" ]; then
			termux_error_exit "Cannot continue this build, hostbuilt tools are missing"
		fi

		# The rest in this function can be skipped when doing
		# a continued build
		return
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && [ "$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED" = "true" ]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not available for on-device builds."
	fi

	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			case "$TERMUX_APP_PACKAGE_MANAGER" in
				"apt") apt install -y termux-elf-cleaner;;
				"pacman") pacman -S termux-elf-cleaner --needed --noconfirm;;
			esac
			TERMUX_ELF_CLEANER="$(command -v termux-elf-cleaner)"
		else
			local TERMUX_ELF_CLEANER_VERSION
			TERMUX_ELF_CLEANER_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/termux-elf-cleaner/build.sh; echo \$TERMUX_PKG_VERSION")
			termux_download \
				"https://github.com/termux/termux-elf-cleaner/releases/download/v${TERMUX_ELF_CLEANER_VERSION}/termux-elf-cleaner" \
				"$TERMUX_ELF_CLEANER" \
				2c57aa961e25dfe44feb87030da3b0e54d314c110b8be6ffede39806ac356cd6
			chmod u+x "$TERMUX_ELF_CLEANER"
		fi

		# Some packages search for libutil, libpthread and librt even
		# though this functionality is provided by libc.  Provide
		# library stubs so that such configure checks succeed.
		mkdir -p "$TERMUX_PREFIX/lib"
		for lib in libutil.so libpthread.so librt.so; do
			if [ ! -f $TERMUX_PREFIX/lib/$lib ]; then
				echo 'INPUT(-lc)' > $TERMUX_PREFIX/lib/$lib
			fi
		done
	fi
}

termux_step_setup_virtual_srcs() {
	[ "$TERMUX_VIRTUAL_PKG_INCLUDE" = "false" ] && return

	if [ -z "$TERMUX_VIRTUAL_PKG_INCLUDE" ]; then
		export TERMUX_VIRTUAL_PKG_INCLUDE=$(find "$TERMUX_PKG_BUILDER_DIR" -mindepth 1 -maxdepth 1 \
			! -name "build.sh" ! -name "*.subpackage.sh" -exec basename {} ';')
	fi

	for src in $TERMUX_VIRTUAL_PKG_INCLUDE; do
		if [ -e "${TERMUX_VIRTUAL_PKG_BUILDER_DIR}/${src}" ]; then
			termux_error_exit "conflict, file '${src}' already exists."
		fi
		ln -sr "${TERMUX_PKG_BUILDER_DIR}/${src}" "${TERMUX_VIRTUAL_PKG_BUILDER_DIR}"
	done
}
