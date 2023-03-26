TERMUX_SUBPKG_DESCRIPTION="Install native static libs from NDK"
TERMUX_SUBPKG_INCLUDE="
share/doc/ndk-multilib-native-static/
"

# Existence of libfoo.a without stub libfoo.so causes troubles.
TERMUX_SUBPKG_DEPENDS="ndk-multilib-native-stubs"

termux_step_create_subpkg_debscripts() {
	local f
	for f in postinst prerm; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@TERMUX_PACKAGE_FORMAT@|${TERMUX_PACKAGE_FORMAT}|g" \
			$TERMUX_PKG_BUILDER_DIR/postinst-header.in > "${f}"
	done
	sed 's|@COMMAND@|ln -sf "'$TERMUX_PREFIX'/opt/ndk-multilib/$triple/lib/$a" "'$TERMUX_PREFIX'/\$triple/lib"|' \
		$TERMUX_PKG_BUILDER_DIR/postinst-native-static.in >> postinst
	sed 's|@COMMAND@|rm -f "'$TERMUX_PREFIX'/$triple/lib/$a"|' \
		$TERMUX_PKG_BUILDER_DIR/postinst-native-static.in >> prerm
	chmod 0700 postinst prerm
}

