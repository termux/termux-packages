TERMUX_PKG_HOMEPAGE=https://github.com/rizsotto/Bear
TERMUX_PKG_DESCRIPTION="Bear is a tool that generates a compilation database for clang tooling."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Nguyen Khanh @nguynkhn"
TERMUX_PKG_VERSION="4.0.3"
TERMUX_PKG_SRCURL=https://github.com/rizsotto/Bear/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99a03b33cb762391d7122ca05ef41f2029cbe9bc43f23e7068dee88637c5b269
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn"

termux_step_make() {
	termux_setup_rust

	local target
	for target in 'bear' 'intercept-preload' 'intercept-wrapper'; do
		cargo build \
			--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
			--target "${CARGO_TARGET_NAME}" \
			--package "${target}" \
			--release
	done
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/bear
	install -Dm755 -t $TERMUX_PREFIX/lib/bear target/${CARGO_TARGET_NAME}/release/{wrapper,libexec.so}
	install -Dm644 -t $TERMUX_PREFIX/share/man/man1 man/bear.1
}
