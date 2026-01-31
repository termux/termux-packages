TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="zig/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.2"
TERMUX_PKG_SRCURL=https://ziglang.org/download/${TERMUX_PKG_VERSION}/zig-bootstrap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a6845459501df3c3264ebc587b02a7094ad14f4f3f7287c48f04457e784d0d85
TERMUX_PKG_DEPENDS="proot"
TERMUX_PKG_ANTI_BUILD_DEPENDS="proot"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# termux-elf-cleaner causes zig Segmentation Fault
TERMUX_PKG_NO_ELF_CLEANER=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_zig

	export TERMUX_PKG_MAKE_PROCESSES

	# zig 0.11.0+ uses 3 stages bootstrapping build system
	# for which NDK can't be used anymore
	unset AS CC CFLAGS CPP CPPFLAGS CXX CXXFLAGS LD LDFLAGS \
		PKGCONFIG PKG_CONFIG PKG_CONFIG_LIBDIR

	# todo: if zig ever builds on-device, implement whatever would work there as an else block
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PKG_CONFIG="/usr/bin/pkg-config"
	fi
}

termux_step_make() {
	# build.patch switch to ninja to make CI build <6 hours
	./build "${ZIG_TARGET_NAME}" baseline
}

termux_step_make_install() {
	rm -fr "${TERMUX_PREFIX}/lib/zig"
	mkdir -p "${TERMUX_PREFIX}/lib"
	cp -fr "out/zig-${ZIG_TARGET_NAME}-baseline" "${TERMUX_PREFIX}/lib/zig"
	#ln -fsv "../lib/zig/zig" "${TERMUX_PREFIX}/bin/zig"

	# https://github.com/ziglang/zig/issues/14146
	# https://github.com/termux/termux-packages/issues/20294
	# Revert to symlink once fixed in upstream
	cat <<- EOL > "${TERMUX_PREFIX}/bin/zig"
	#!${TERMUX_PREFIX}/bin/sh
	if command -v proot >/dev/null; then
	proot -b "${TERMUX_PREFIX}/bin/env:/usr/bin/env" "${TERMUX_PREFIX}/lib/zig/zig" "\$@"
	else
	"${TERMUX_PREFIX}/lib/zig/zig" "\$@"
	fi
	EOL
	chmod 700 "${TERMUX_PREFIX}/bin/zig"
}

termux_step_post_massage() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then return; fi
	if [[ -z "$(find /proc/sys/fs/binfmt_misc -type f -name 'qemu-*')" ]]; then return; fi

	( # self test
		cd "${TERMUX_PKG_TMPDIR}" || termux_error_exit "Failed to perform selftest for Zig $TERMUX_PKG_VERSION"
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL/lib/zig/zig" version
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL/lib/zig/zig" init
	)
}

termux_step_create_debscripts() {
	cat <<- EOL > postinst
	#!${TERMUX_PREFIX}/bin/sh
	echo "NOTE:"
	echo "${TERMUX_PREFIX}/bin/zig is now a proot wrapper script to"
	echo "${TERMUX_PREFIX}/lib/zig/zig to workaround issue:"
	echo "error: warning: Encountered error: FileNotFound, falling back to default ABI and dynamic linker"
	EOL
	chmod 700 postinst
}
