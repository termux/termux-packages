TERMUX_SUBPKG_INCLUDE="
bin/ld.lld
bin/ld64.lld
bin/lld
bin/lld-link
bin/wasm-ld
include/lld/
lib/cmake/lld/
lib/liblld*.a
"
TERMUX_SUBPKG_DESCRIPTION="LLVM-based linker"
TERMUX_SUBPKG_CONFLICTS="binutils (<< 2.37-5)"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/ld ld $TERMUX_PREFIX/bin/lld 20
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove ld $TERMUX_PREFIX/bin/ld
		fi
	fi
	EOF
}
