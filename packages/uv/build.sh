TERMUX_PKG_HOMEPAGE=https://docs.astral.sh/uv/
TERMUX_PKG_DESCRIPTION="An extremely fast Python package installer and resolver, written in Rust."
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.25"
TERMUX_PKG_SRCURL=https://github.com/astral-sh/uv/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7b8d13b623a097ca320fc5828151a1c65f5669e9833d9f54a75fbff406e2206e
TERMUX_PKG_BUILD_DEPENDS="zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# Dummy CMake toolchain file to workaround build error:
	# error: failed to run custom build command for `libz-ng-sys v1.1.15`
	# ...
	# CMake Error at /home/builder/.termux-build/_cache/cmake-3.28.3/share/cmake-3.28/Modules/Platform/Android-Determine.cmake:217 (message):
	# Android: Neither the NDK or a standalone toolchain was found.
	export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
	touch "${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf "${CARGO_HOME}"/registry/src/*/sys-info-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	patch -p1 -d "${CARGO_HOME}"/registry/src/*/sys-info-* \
	-i "${TERMUX_PKG_BUILDER_DIR}"/0001-sys-info-replace-index-with-strchr.diff
}

termux_step_make() {
	PKG_CONFIG_ALL_DYNAMIC=1 \
	ZSTD_SYS_USE_PKG_CONFIG=1 \
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin target/"${CARGO_TARGET_NAME}"/release/uv
	install -Dm700 -t "${TERMUX_PREFIX}"/bin target/"${CARGO_TARGET_NAME}"/release/uvx
}

termux_step_post_make_install() {
	# Make a placeholder for shell-completions (to be filled with postinst)
	mkdir -p "${TERMUX_PREFIX}"/share/bash-completion/completions
	mkdir -p "${TERMUX_PREFIX}"/share/elvish/lib
	mkdir -p "${TERMUX_PREFIX}"/share/fish/vendor_completions.d
	mkdir -p "${TERMUX_PREFIX}"/share/zsh/site-functions
	touch "${TERMUX_PREFIX}"/share/bash-completion/completions/uv
	touch "${TERMUX_PREFIX}"/share/elvish/lib/uv.elv
	touch "${TERMUX_PREFIX}"/share/fish/vendor_completions.d/uv.fish
	touch "${TERMUX_PREFIX}"/share/zsh/site-functions/_uv
}

termux_step_post_massage() {
	rm -rf "${CARGO_HOME}"/registry/src/*/sys-info-*
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh

		uv generate-shell-completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/uv"
		uv generate-shell-completion elvish > "$TERMUX_PREFIX/share/elvish/lib/uv.elv"
		uv generate-shell-completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/uv.fish"
		uv generate-shell-completion zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_uv"
	EOF
}
