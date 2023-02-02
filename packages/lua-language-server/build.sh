TERMUX_PKG_HOMEPAGE="https://github.com/sumneko/lua-language-server"
TERMUX_PKG_DESCRIPTION="Sumneko Lua Language Server coded in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
TERMUX_PKG_VERSION="3.6.9"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_SRCURL="git+https://github.com/sumneko/lua-language-server"
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

_patch_on_device() {
	if [ "${TERMUX_ON_DEVICE_BUILD}" = true ]; then
		(
			cd "${TERMUX_PKG_SRCDIR}"
			patch --silent -p1 < "${TERMUX_PKG_BUILDER_DIR}"/android.diff
		)
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
	CFLAGS+=" -DBEE_ENABLE_FILESYSTEM"     # without this, it tries to link against its own filesystem lib and fails.
	CFLAGS+=" -Wno-unknown-warning-option" # for -Wno-maybe-uninitialized argument.

	sed \
		-e "s%\@FLAGS\@%${CFLAGS} ${CPPFLAGS}%g" \
		-e "s%\@LDFLAGS\@%${LDFLAGS}%g" \
		"${TERMUX_PKG_BUILDER_DIR}"/make.lua.diff | patch --silent -p1

	"${TERMUX_PKG_HOSTBUILD_DIR}"/3rd/luamake/luamake \
		-cc "${CC}" \
		-hostos "android"
}

termux_step_make_install() {
	local datadir="${TERMUX_PREFIX}/share/${TERMUX_PKG_NAME}"

	cat > "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}" <<- EOF
		#!${TERMUX_PREFIX}/bin/bash

		# After action of termux-elf-cleaner lua-language-server's binary is unable to
		# determine its version, so provide it manually.
		if [ "\$1" = "--version" ]; then
			echo "${TERMUX_PKG_NAME}: ${TERMUX_PKG_VERSION}"
		else
			TMPPATH=\$(mktemp -d "${TERMUX_PREFIX}/tmp/${TERMUX_PKG_NAME}.XXXX")

			exec ${datadir}/bin/${TERMUX_PKG_NAME} \\
				--logpath="\${TMPPATH}/log" \\
				--metapath="\${TMPPATH}/meta" \\
				"\${@}"
		fi

	EOF

	chmod 0700 "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}"

	install -Dm700 -t "${datadir}"/bin ./bin/"${TERMUX_PKG_NAME}"
	install -Dm600 -t "${datadir}" ./{main,debugger}.lua
	install -Dm600 -t "${datadir}"/bin ./bin/main.lua

	cp -r ./script ./meta ./locale "${datadir}"
}
