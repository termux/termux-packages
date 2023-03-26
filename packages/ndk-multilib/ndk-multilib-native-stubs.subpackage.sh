TERMUX_SUBPKG_DESCRIPTION="Install native stubs for shared libs from NDK"
TERMUX_SUBPKG_INCLUDE="
share/doc/ndk-multilib-native-stubs/
"

termux_step_create_subpkg_debscripts() {
	local f
	for f in postinst prerm; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@TERMUX_PACKAGE_FORMAT@|${TERMUX_PACKAGE_FORMAT}|g" \
			$TERMUX_PKG_BUILDER_DIR/postinst-header.in > "${f}"
	done
	sed 's|@COMMAND@|ln -sf "'$TERMUX_PREFIX'/opt/ndk-multilib/$triple/lib/$so" "'$TERMUX_PREFIX'/\$triple/lib"|' \
		$TERMUX_PKG_BUILDER_DIR/postinst-native-stubs.in >> postinst
	sed 's|@COMMAND@|rm -f "'$TERMUX_PREFIX'/$triple/lib/$so"|' \
		$TERMUX_PKG_BUILDER_DIR/postinst-native-stubs.in >> prerm
	chmod 0700 postinst prerm
}

