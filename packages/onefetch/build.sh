TERMUX_PKG_HOMEPAGE=https://onefetch.dev/
TERMUX_PKG_DESCRIPTION="A command-line Git information tool written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.21.0"
TERMUX_PKG_SRCURL=https://github.com/o2sh/onefetch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a035bc44ef0c04a330b409e08ee61ac8a66a56cb672f87a824d4c0349989eaf2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.9`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-3.28.3/share/cmake-3.28/Modules/Platform/Android-Determine.cmake:217 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
	touch "${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
}

termux_step_make() {
	cargo build \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME \
		--release
}

termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/onefetch "$TERMUX_PREFIX"/bin

	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/bash-completion/completions/onefetch.bash
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/zsh/site-functions/_onefetch
	install -Dm644 /dev/null "$TERMUX_PREFIX"/share/fish/vendor_completions.d/onefetch.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		onefetch --generate bash > ${TERMUX_PREFIX}/share/bash-completion/completions/onefetch.bash
		onefetch --generate zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_onefetch
		onefetch --generate fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/onefetch.fish
	EOF
}
