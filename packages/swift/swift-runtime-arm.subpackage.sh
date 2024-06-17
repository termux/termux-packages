TERMUX_SUBPKG_DESCRIPTION="Swift runtime libraries for Android armv7"
TERMUX_SUBPKG_INCLUDE="opt/ndk-multilib/arm-linux-androideabi/lib/lib[FXs]*.so"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="ndk-multilib"

termux_step_create_subpkg_debscripts() {
	local file
	for file in postinst prerm; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@TERMUX_PACKAGE_FORMAT@|${TERMUX_PACKAGE_FORMAT}|g" \
			-e "s|@SWIFT_TRIPLE@|arm-linux-androideabi|g" \
			$TERMUX_PKG_BUILDER_DIR/trigger-header > "${file}"
	done
	sed 's|@COMMAND@|ln -sf "'$TERMUX_PREFIX'/opt/ndk-multilib/arm-linux-androideabi/lib/lib$so.so" "$install_path"|' \
		$TERMUX_PKG_BUILDER_DIR/trigger-command >> postinst
	sed 's|@COMMAND@|rm -f "$install_path/lib$so.so"|' \
		$TERMUX_PKG_BUILDER_DIR/trigger-command >> prerm
	chmod 0700 postinst prerm
}
