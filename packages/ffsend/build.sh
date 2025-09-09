TERMUX_PKG_HOMEPAGE=https://gitlab.com/timvisee/ffsend
TERMUX_PKG_DESCRIPTION="A fully featured Firefox Send client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.77"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://gitlab.com/timvisee/ffsend/-/archive/v$TERMUX_PKG_VERSION/ffsend-v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c9f94dc548339f516d93ffaa40e305c926cddc4cc0a548e1c13b0ad7a6fecd8d
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features --features crypto-openssl,send2,send3,history,archive,qrcode,urlshorten,infer-command"

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/traitobject \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/traitobject/ \
		< "$TERMUX_PKG_BUILDER_DIR"/traitobject-rust-1.87.diff

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'traitobject = { path = "./vendor/traitobject" }' >> Cargo.toml
}
