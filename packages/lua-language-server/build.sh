TERMUX_PKG_HOMEPAGE="https://github.com/sumneko/lua-language-server"
TERMUX_PKG_DESCRIPTION="Sumneko Lua Language Server coded in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION=2.4.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/sumneko/lua-language-server.git
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	termux_setup_ninja
	mkdir 3rd
        cp -a $TERMUX_PKG_SRCDIR/3rd/luamake 3rd/
        cd 3rd/luamake
	./compile/install.sh
}

termux_step_make() {
	termux_setup_ninja
	$TERMUX_PKG_HOSTBUILD_DIR/3rd/luamake/luamake -cc "${CC}" -flags "${CFLAGS} ${CPPFLAGS}" -hostos "android"
}

termux_step_make_install() {
	local INSTALL_DIR="${TERMUX_PREFIX}/lib/lua-language-server"

	cat >"lua-language-server" <<-EOF
		#!${TERMUX_PREFIX}/bin/bash

		if [ "\$1" = "--start-lsp" ]; then
			# use wrapper because lsp paths are relative
			exec ${INSTALL_DIR}/lua-language-server -E ${INSTALL_DIR}/main.lua
		elif [ "\$1" = "-h" ] || [ "\$1" = "--help" ]; then
			echo -e "\n\e[32mTo start language server use --start-lsp\e[39m\n"
			exec ${INSTALL_DIR}/lua-language-server "\$@"
		else
			exec ${INSTALL_DIR}/lua-language-server "\$@"
		fi
	EOF

	install -Dm755 ./lua-language-server "${TERMUX_PREFIX}/bin"

	mkdir -p "${INSTALL_DIR}"
	install -Dm755 ./bin/Android/* "${INSTALL_DIR}"
	cp -r ./script ./meta ./tools ./platform.lua ./locale ./debugger.lua ./main.lua "${INSTALL_DIR}"
}

termux_step_create_debscripts() {
	cat >prerm <<-EOF
		#!${TERMUX_PREFIX}/bin/bash
		if [ "$TERMUX_PACKAGE_FORMAT" != "pacman" ] && [ "\$1" != "remove" ]; then exit 0; fi

		# log files created by lsp is not removed automatically
		rm -rf "${TERMUX_PREFIX}/lib/lua-language-server"
	EOF
}
