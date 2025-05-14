TERMUX_SUBPKG_DESCRIPTION="A native debugger extension for code-oss based on LLDB"
TERMUX_SUBPKG_INCLUDE="share/doc/code-oss-extension-codelldb"
TERMUX_SUBPKG_DEPENDS="code-oss"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true

termux_step_create_subpkg_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		code-oss --install-extension "$TERMUX_PREFIX/opt/vsix-packages/codelldb-$TERMUX_PKG_FULLVERSION.vsix"
		exit 0
	EOF
	cat <<-EOF >./prerm
		#!${TERMUX_PREFIX}/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ] && [ "\$1" != "remove" ]; then
			exit 0
		fi
		code-oss --uninstall-extension vadimcn.vscode-lldb
		exit 0
	EOF
	chmod +x ./postinst ./prerm
}
