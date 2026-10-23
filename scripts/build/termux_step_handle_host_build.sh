termux_step_handle_host_build() {
	[[ "$TERMUX_PKG_METAPACKAGE" == "true" || "$TERMUX_PKG_HOSTBUILD" == "false" ]] && return

	cd "$TERMUX_PKG_SRCDIR"
	local -a HOST_BUILD_PATCHES=() VARIABLES=()
	readarray -t VARIABLES < <(compgen -v)
	readarray -t HOST_BUILD_PATCHES < <(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name \*.patch.beforehostbuild | sort)
	for patch in "${HOST_BUILD_PATCHES[@]}"; do
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
							&& line=${line//"@@${var}@@"/"${!var}"}
						done
					printf '%s\n' "$line"
				done
			) | patch --silent -p1
	done

	if [[ ! -f "$TERMUX_HOSTBUILD_MARKER" ]]; then
		rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
		mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR"
		cd "$TERMUX_PKG_HOSTBUILD_DIR"
		termux_step_host_build
		touch "$TERMUX_HOSTBUILD_MARKER"
	fi
}
