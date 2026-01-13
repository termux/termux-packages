TERMUX_PKG_HOMEPAGE="https://github.com/sumneko/lua-language-server"
TERMUX_PKG_DESCRIPTION="Sumneko Lua Language Server coded in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="3.16.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_SRCURL="git+https://github.com/sumneko/lua-language-server"
TERMUX_PKG_DEPENDS="libandroid-spawn, binutils-libs, libc++"
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

_load_ubuntu_packages() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
		export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
		LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
	fi
}

termux_step_host_build() {
	_patch_on_device
	termux_setup_ninja

	mkdir 3rd
	cp -a "${TERMUX_PKG_SRCDIR}"/3rd/luamake 3rd/

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local -a ubuntu_packages=(
			"binutils"
			"binutils-common"
			"binutils-dev"
			"binutils-x86-64-linux-gnu"
			"libbinutils"
			"libctf-nobfd0"
			"libctf0"
			"libgprofng0"
			"libsframe1"
			"libunwind-dev"
			"libunwind8"
		)

		termux_download_ubuntu_packages "${ubuntu_packages[@]}"

		_load_ubuntu_packages

		patch="$TERMUX_PKG_BUILDER_DIR/hostbuild-force-link.diff"
		echo "Applying patch: $(basename "$patch")"
		test -f "$patch" && sed \
			-e "s%\@TERMUX_PKG_HOSTBUILD_DIR\@%${TERMUX_PKG_HOSTBUILD_DIR}%g" \
			"$patch" | patch --silent -p1
	fi

	cd 3rd/luamake
	./compile/install.sh
}

termux_step_make() {
	termux_setup_ninja

	CFLAGS+=" -DBEE_ENABLE_FILESYSTEM"     # without this, it tries to link against its own filesystem lib and fails.
	CFLAGS+=" -Wno-unknown-warning-option" # for -Wno-maybe-uninitialized argument.

	sed \
		-e "s%\@FLAGS\@%${CFLAGS} ${CPPFLAGS}%g" \
		-e "s%\@LDFLAGS\@%${LDFLAGS}%g" \
		"${TERMUX_PKG_BUILDER_DIR}"/make.lua.diff | patch --silent -p1

	_load_ubuntu_packages

	patch="$TERMUX_PKG_BUILDER_DIR/force-cast-unw_context_t.diff"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && {
		patch --silent -p1 -d "$TERMUX_PKG_SRCDIR/3rd/bee.lua/bee/crash/linux" < "$patch"
		patch --silent -p1 -d "$TERMUX_PKG_SRCDIR/3rd/luamake/bee.lua/bee/crash/linux" < "$patch"
	}

	"${TERMUX_PKG_HOSTBUILD_DIR}"/3rd/luamake/luamake \
		-cc "${CC}" \
		-hostos "android"
}

termux_step_make_install() {
	local datadir="${TERMUX_PREFIX}/share/${TERMUX_PKG_NAME}"

	cat > "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}" <<- EOF
		#!${TERMUX_PREFIX}/bin/bash
		TMPPATH="\$(mktemp -d "${TERMUX_PREFIX}/tmp/${TERMUX_PKG_NAME}.XXXX")"

		exec ${datadir}/bin/${TERMUX_PKG_NAME} \\
		--logpath="\${TMPPATH}/log" \\
		--metapath="\${TMPPATH}/meta" \\
		"\${@}"
	EOF

	chmod 0700 "${TERMUX_PREFIX}/bin/${TERMUX_PKG_NAME}"

	install -Dm700 -t "${datadir}"/bin ./bin/"${TERMUX_PKG_NAME}"
	install -Dm600 -t "${datadir}" ./{main,debugger}.lua
	install -Dm600 -t "${datadir}"/bin ./bin/main.lua

	# needed for --version
	install -Dm600 -t "${datadir}" ./changelog.md

	cp -r ./script ./meta ./locale "${datadir}"
}
