TERMUX_PKG_HOMEPAGE="https://github.com/sumneko/lua-language-server"
TERMUX_PKG_DESCRIPTION="Sumneko Lua Language Server coded in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION=2.5.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_SRCURL="https://github.com/sumneko/lua-language-server.git"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

_patch_on_device() {
	if [ "${TERMUX_ON_DEVICE_BUILD}" = true ]; then
		current_dir=$(pwd)

		cd "${TERMUX_PKG_SRCDIR}"
		patch --silent -p1 <"${TERMUX_PKG_BUILDER_DIR}"/android.patch.ondevice.beforehostbuild

		cd "${current_dir}"
	fi
}

termux_step_host_build() {
	_patch_on_device
	termux_setup_ninja

	mkdir 3rd
	cp -a "${TERMUX_PKG_SRCDIR}"/3rd/luamake 3rd/

	cd 3rd/luamake
	./compile/install.sh
}

termux_step_make() {
	sed \
		-e "s%\@FLAGS\@%${CFLAGS} ${CPPFLAGS}%g" \
		-e "s%\@LDFLAGS\@%${LDFLAGS}%g" \
		"${TERMUX_PKG_BUILDER_DIR}"/make.lua.diff | patch --silent -p1

	"${TERMUX_PKG_HOSTBUILD_DIR}"/3rd/luamake/luamake \
		-cc "${CC}" \
		-hostos "android"
}

termux_step_make_install() {
	local INSTALL_DIR="${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}"

	cat >"${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}" <<-EOF
		#!${TERMUX_PREFIX}/bin/bash

		# After action of termux-elf-cleaner lua-language-server's binary(ELF) is unable to
		# determine its version, so provide it manually.
		if [ "\$1" = "--version" ]; then
			echo "${TERMUX_PKG_NAME}: ${TERMUX_PKG_VERSION}"
		else
			TMPPATH=\$(mktemp -d "${TERMUX_PREFIX}/tmp/${TERMUX_PKG_NAME}.XXXX")

			exec ${INSTALL_DIR}/bin/${TERMUX_PKG_NAME} \\
				--logpath="\${TMPPATH}/log" \\
				--metapath="\${TMPPATH}/meta" \\
				"\${@}"
		fi

	EOF

	chmod 744 "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}"

	install -Dm744 -t "${INSTALL_DIR}"/bin ./bin/"${TERMUX_PKG_NAME}"
	install -Dm644 -t "${INSTALL_DIR}" ./{main,debugger}.lua
	install -Dm644 -t "${INSTALL_DIR}"/bin ./bin/main.lua

	cp -r ./script ./meta ./locale "${INSTALL_DIR}"
}
