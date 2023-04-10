TERMUX_PKG_HOMEPAGE=https://findomain.app/
TERMUX_PKG_DESCRIPTION="Findomain is the fastest subdomain enumerator and the only one written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.0.0"
TERMUX_PKG_SRCURL=https://github.com/Findomain/Findomain/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=98cdb137ea96acfcc4739718d9abedc9982a01b367e921cefae8516271d9739e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	for d in $CARGO_HOME/registry/src/github.com-*/trust-dns-resolver-*; do
		sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
			$TERMUX_PKG_BUILDER_DIR/trust-dns-resolver.diff \
			| patch --silent -p1 -d ${d} || :
	done
}
