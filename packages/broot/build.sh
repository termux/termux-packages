TERMUX_PKG_HOMEPAGE=https://github.com/Canop/broot
TERMUX_PKG_DESCRIPTION="A better way to navigate directories"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.62.0"
TERMUX_PKG_SRCURL=https://github.com/Canop/broot/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7c3445a6eef45fe67fe2e1f4e0e1f9dca796237d6303615e31b07798cc1716ba
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	sed -i '/trash/d' $TERMUX_PKG_SRCDIR/Cargo.toml
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release

	mkdir -p build
	cp man/page build/broot.1
	sed -i "s/#version/$TERMUX_PKG_VERSION/g" build/broot.1
	sed -i "s/#date/$(date -r man/page +'%Y\/%m\/%d')/g" build/broot.1

}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/broot
	install -Dm644 -t $TERMUX_PREFIX/share/man/man1 build/broot.1
}
