termux_step_patch_package() {
	[[ "$TERMUX_PKG_METAPACKAGE" == "true" ]] && return
	local -a PATCHES=() DEBUG_PATCHES=() ON_DEVICE_PATCHES=() VARIABLES=()
	readarray -t VARIABLES < <(compgen -v)

	cd "$TERMUX_PKG_SRCDIR"
	# Suffix patch with ".patch32" or ".patch64" to only apply for
	# these bitnesses
	readarray -t PATCHES < <(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 \
			     -name \*.patch -o -name \*.patch$TERMUX_ARCH_BITS | sort)
	[[ "$TERMUX_DEBUG_BUILD" == "true" ]] \
		&& readarray -t DEBUG_PATCHES < <(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name \*.patch.debug | sort)

	# .patch.ondevice patches should only be applied when building
	# on device
	[[ "$TERMUX_ON_DEVICE_BUILD" = "true" ]] \
		&& readarray -t ON_DEVICE_PATCHES < <(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name \*.patch.ondevice | sort)

	shopt -s nullglob
	for patch in "${PATCHES[@]}" "${DEBUG_PATCHES[@]}" "${ON_DEVICE_PATCHES[@]}"; do
		echo "Applying patch: $(basename $patch)"
		test -f "$patch" && sed \
			-e "s%\@TERMUX_APP_PACKAGE\@%${TERMUX_APP_PACKAGE}%g" \
			-e "s%\@TERMUX_BASE_DIR\@%${TERMUX_BASE_DIR}%g" \
			-e "s%\@TERMUX_CACHE_DIR\@%${TERMUX_CACHE_DIR}%g" \
			-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" \
			-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
			-e "s%\@TERMUX_PREFIX_CLASSICAL\@%${TERMUX_PREFIX_CLASSICAL}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX\@%${TERMUX_ENV__S_TERMUX}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX_APP\@%${TERMUX_ENV__S_TERMUX_APP}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX_API_APP\@%${TERMUX_ENV__S_TERMUX_API_APP}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX_ROOTFS\@%${TERMUX_ENV__S_TERMUX_ROOTFS}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX_EXEC\@%${TERMUX_ENV__S_TERMUX_EXEC}%g" \
			"$patch" | (
				while IFS= read -r line; do
					[[ $line == +[!+]* && $line == *@@*@@* ]] \
						&& for var in "${VARIABLES[@]}"; do
							[[ $line == *"@@${var}@@"* ]] \
							&& line="${line//"@@${var}@@"/"${!var}"}"
						done
					printf '%s\n' "$line"
				done
			) | patch --silent -p1
	done
	shopt -u nullglob
}
