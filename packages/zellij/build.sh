TERMUX_PKG_HOMEPAGE="https://zellij.dev/"
TERMUX_PKG_DESCRIPTION="A terminal workspace with batteries included"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Jonathan Lei <me@xjonathan.dev>"
TERMUX_PKG_VERSION="0.43.0"
TERMUX_PKG_SRCURL="https://github.com/zellij-org/zellij/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fd1cb54df0453f7f1340bb293a2682bbeacbd307156aab919acdf715e36b6ee1
TERMUX_PKG_BUILD_DEPENDS="openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# wasmer doesn't support these platforms yet
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust
	export OPENSSL_NO_VENDOR=1

	export TARGET_CMAKE_GENERATOR="Ninja"

	# Setup subsequent cmake running inside cargo
	# Crate used to invoke cmake does not work fine with cross-compilation so we wrap cmake
	_CMAKE="$TERMUX_PKG_TMPDIR/bin/cmake"
	mkdir -p "$(dirname "$_CMAKE")"

	echo "#!$(readlink /proc/$$/exe)" > "$_CMAKE"
	echo "echo CMAKE \"\$@\"" >> "$_CMAKE"
	echo "[[ \"\$@\" =~ \"--build\" ]] && exec $(command -v cmake) \"\$@\" || \
	exec $(command -v cmake) \
	-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=\"$TERMUX_STANDALONE_TOOLCHAIN\" \
	-DCMAKE_SYSTEM_NAME=Android \
	-DCMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL \
	-DCMAKE_LINKER=\"$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD\" \
	-DCMAKE_MAKE_PROGRAM=\"$(command -v ninja)\" \"\$@\"" >> "$_CMAKE"
	chmod +x "$_CMAKE"

	export PATH="$(dirname "$_CMAKE"):$PATH"
	CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
}

termux_step_make() {
	cargo build --jobs ${TERMUX_PKG_MAKE_PROCESSES} --target ${CARGO_TARGET_NAME} --release
}

termux_step_make_install() {
	install -Dm700 -t ${TERMUX_PREFIX}/bin target/${CARGO_TARGET_NAME}/release/zellij

	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/bash-completion/completions/zellij.bash
	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/zsh/site-functions/_zellij
	install -Dm644 /dev/null ${TERMUX_PREFIX}/share/fish/vendor_completions.d/zellij.fish
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		zellij setup --generate-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/zellij.bash
		zellij setup --generate-completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_zellij
		zellij setup --generate-completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/zellij.fish
	EOF
}
