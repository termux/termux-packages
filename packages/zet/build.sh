TERMUX_PKG_HOMEPAGE=https://github.com/yarrow/zet
TERMUX_PKG_DESCRIPTION="CLI utility to find the union, intersection, difference of files considered as sets of lines, alternative to comm(1)/uniq(1)"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.1"
TERMUX_PKG_SRCURL=https://github.com/yarrow/zet/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a6f431927c16b22516e78a9ec7864d99e2676abae3acb46101df1c287e16f267
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/$TERMUX_PKG_NAME
	install -Dm644 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README*
}
