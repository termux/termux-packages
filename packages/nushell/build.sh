TERMUX_PKG_HOMEPAGE=https://www.nushell.sh
TERMUX_PKG_DESCRIPTION="A new type of shell operating on structured data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.98.0"
TERMUX_PKG_SRCURL=https://github.com/nushell/nushell/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c77fd63c4a5f2d35f7dcbb3e9bd76dfaa23acc6bc21fb1de4e7a4a94dc458839
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
"

termux_step_pre_configure() {
	termux_setup_rust

	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}
