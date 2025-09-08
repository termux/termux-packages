TERMUX_PKG_HOMEPAGE="https://zellij.dev/"
TERMUX_PKG_DESCRIPTION="A terminal workspace with batteries included"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Jonathan Lei <me@xjonathan.dev>"
TERMUX_PKG_VERSION="0.43.1"
TERMUX_PKG_SRCURL="https://github.com/zellij-org/zellij/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e9fd24190869be6e9e8d731df2ccd0b3b1dd368ae9dbb9d620ec905b83e325ec
TERMUX_PKG_BUILD_DEPENDS="openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# wasmer doesn't support these platforms yet
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust

	cargo install --force --locked bindgen-cli
	export BINDGEN_EXTRA_CLANG_ARGS="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	case "${TERMUX_ARCH}" in
	arm) BINDGEN_EXTRA_CLANG_ARGS+=" --target=arm-linux-androideabi -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/include/c++/v1 -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/arm-linux-androideabi" ;;
	*) BINDGEN_EXTRA_CLANG_ARGS+=" --target=${TERMUX_ARCH}-linux-android -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/include/c++/v1 -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/${TERMUX_ARCH}-linux-android" ;;
	esac

	export OPENSSL_NO_VENDOR=1

	# aws-lc-sys
	export TARGET_CMAKE_GENERATOR=Ninja
	export ANDROID_STANDALONE_TOOLCHAIN=${TERMUX_STANDALONE_TOOLCHAIN}
	export CFLAGS_${CARGO_TARGET_NAME//-/_}="${CFLAGS} --target=${CARGO_TARGET_NAME}${TERMUX_PKG_API_LEVEL}"
	export CXXFLAGS_${CARGO_TARGET_NAME//-/_}="${CXXFLAGS} --target=${CARGO_TARGET_NAME}${TERMUX_PKG_API_LEVEL}"

	# clash with rust host build
	unset CFLAGS
}

termux_step_make() {
	cargo build --jobs ${TERMUX_PKG_MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
}

termux_step_make_install() {
	install -Dm700 -t ${TERMUX_PREFIX}/bin target/${CARGO_TARGET_NAME}/release/zellij

	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/bash-completion/completions/zellij.bash
	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/zsh/site-functions/_zellij
	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/fish/vendor_completions.d/zellij.fish

	unset \
		ANDROID_STANDALONE_TOOLCHAIN \
		BINDGEN_EXTRA_CLANG_ARGS \
		CFLAGS_${CARGO_TARGET_NAME//-/_} \
		CXXFLAGS_${CARGO_TARGET_NAME//-/_} \
		OPENSSL_NO_VENDOR \
		TARGET_CMAKE_GENERATOR
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		zellij setup --generate-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/zellij.bash
		zellij setup --generate-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_zellij
		zellij setup --generate-completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/zellij.fish
	EOF
}
