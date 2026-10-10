TERMUX_PKG_HOMEPAGE=https://github.com/ouch-org/ouch
TERMUX_PKG_DESCRIPTION="Painless compression and decompression for your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.8.3"
TERMUX_PKG_SRCURL="https://github.com/ouch-org/ouch/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f695393cbbd89cf5a2095c32235e585a85432ccfb902c78d2a2e9787abbb439c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-utimes, libc++"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f rust-toolchain.toml

	termux_setup_rust

	# unrar-ng-sys compiles C++ code but does not link a C++ standard library,
	# and its symlink handling needs lutimes which bionic lacks
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export CARGO_TARGET_"${env_host}"_RUSTFLAGS+=" -C link-arg=-lc++_shared -C link-arg=-landroid-utimes"

	# libbzip3-sys runs bindgen, which needs a versioned target triple
	export BINDGEN_EXTRA_CLANG_ARGS="--target=${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL} --sysroot=${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"

	# build.rs generates man pages and shell completions into this folder
	export OUCH_ARTIFACTS_FOLDER="${TERMUX_PKG_SRCDIR}/artifacts"
}

termux_step_make() {
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" \
		"target/${CARGO_TARGET_NAME}/release/${TERMUX_PKG_NAME}"

	# Man pages
	install -Dm600 -t "${TERMUX_PREFIX}/share/man/man1" artifacts/*.1

	# Shell completions
	install -Dm600 artifacts/_ouch \
		"${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	install -Dm600 artifacts/ouch.bash \
		"${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	install -Dm600 artifacts/ouch.fish \
		"${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	install -Dm600 artifacts/ouch.elv \
		"${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
	install -Dm600 artifacts/ouch.nu \
		"${TERMUX_PREFIX}/share/nushell/vendor/autoload/${TERMUX_PKG_NAME}.nu"
}
