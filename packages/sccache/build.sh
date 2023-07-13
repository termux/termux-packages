TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/sccache
TERMUX_PKG_DESCRIPTION="sccache is ccache with cloud storage"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.4"
TERMUX_PKG_SRCURL=https://github.com/mozilla/sccache/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=86538bb9e2af88e1e5d519f7a3b6afeac25278eab283ff5a52a715b4f07427ab
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/sccache
}
