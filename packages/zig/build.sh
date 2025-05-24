TERMUX_PKG_HOMEPAGE=https://ziglang.org
TERMUX_PKG_DESCRIPTION="General-purpose programming language and toolchain"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="zig/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.1"
TERMUX_PKG_SRCURL=https://github.com/ziglang/zig/releases/download/${TERMUX_PKG_VERSION}/zig-bootstrap-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=89b2fce50bfbb1eee29c382193d22c6eb0c7da3a96b5ba6d05e0af2945b3ca3d
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
	# which NDK cant be used anymore
	unset AS CC CFLAGS CPP CPPFLAGS CXX CXXFLAGS LD LDFLAGS
}

termux_step_make() {
	# build.patch switch to ninja to make CI build <6 hours
	./build "${ZIG_TARGET_NAME}" baseline
}

termux_step_make_install() {
	cp -fr "out/zig-${ZIG_TARGET_NAME}-baseline" "${TERMUX_PREFIX}/lib/zig"
	ln -fsv "../lib/zig/zig" "${TERMUX_PREFIX}/bin/zig"
}

termux_step_post_massage() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then return; fi
	if [[ -z "$(find /proc/sys/fs/binfmt_misc -type f -name 'qemu-*')" ]]; then return; fi

	( # self test
		cd "${TERMUX_PKG_TMPDIR}" || termux_error_exit "Failed to perform selftest for Zig $TERMUX_PKG_VERSION"
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL/bin/zig" version
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL/bin/zig" init
	)
}
