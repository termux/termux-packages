termux_step_patch_package() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	cd "$TERMUX_PKG_SRCDIR"
	# Suffix patch with ".patch32" or ".patch64" to only apply for
	# these bitnesses
	local PATCHES=$(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 \
			     -name \*.patch -o -name \*.patch$TERMUX_ARCH_BITS | sort)
	local DEBUG_PATCHES=""
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		DEBUG_PATCHES=$(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name \*.patch.debug | sort)
	fi
	local ON_DEVICE_PATCHES=""
	# .patch.ondevice patches should only be applied when building
	# on device
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		ON_DEVICE_PATCHES=$(find $TERMUX_PKG_BUILDER_DIR -mindepth 1 -maxdepth 1 -name \*.patch.ondevice | sort)
	fi
	shopt -s nullglob
	for patch in $PATCHES $DEBUG_PATCHES $ON_DEVICE_PATCHES; do
		echo "Applying patch: $(basename $patch)"
		test -f "$patch" && sed \
			-e "s%\@TERMUX_APP_PACKAGE\@%${TERMUX_APP_PACKAGE}%g" \
			-e "s%\@TERMUX_BASE_DIR\@%${TERMUX_BASE_DIR}%g" \
			-e "s%\@TERMUX_CACHE_DIR\@%${TERMUX_CACHE_DIR}%g" \
			-e "s%\@TERMUX_HOME\@%${TERMUX_ANDROID_HOME}%g" \
			-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
			-e "s%\@TERMUX_PREFIX_CLASSICAL\@%${TERMUX_PREFIX_CLASSICAL}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX\@%${TERMUX_ENV__S_TERMUX}%g" \
			-e "s%\@TERMUX_ENV__SE_TERMUX\@%${TERMUX_ENV__SE_TERMUX}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX_APP\@%${TERMUX_ENV__S_TERMUX_APP}%g" \
			-e "s%\@TERMUX_ENV__SE_TERMUX_APP\@%${TERMUX_ENV__SE_TERMUX_APP}%g" \
			-e "s%\@TERMUX_ENV__S_TERMUX_EXEC\@%${TERMUX_ENV__S_TERMUX_EXEC}%g" \
			-e "s%\@TERMUX_ENV__SE_TERMUX_EXEC\@%${TERMUX_ENV__SE_TERMUX_EXEC}%g" \
			"$patch" | patch --silent -p1
	done
	shopt -u nullglob
}
