TERMUX_PKG_HOMEPAGE=https://github.com/Byron/gitoxide
TERMUX_PKG_DESCRIPTION="Rust implementation of Git"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.39.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Byron/gitoxide/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=50d8dcaa16e9a2dbcd89d6a68cae0c136734ca4b64a861a48ff6784e9939d4ca
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	for d in $CARGO_HOME/registry/src/*/trust-dns-resolver-*; do
		sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
			$TERMUX_PKG_BUILDER_DIR/trust-dns-resolver.diff \
			| patch --silent -p1 -d ${d} || :
	done

	if [ "$TERMUX_ARCH" == "x86_64" ]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi
}

termux_step_make() {
	cargo build \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME \
		--release \
		--no-default-features \
		--features max-pure
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin \
		target/${CARGO_TARGET_NAME}/release/ein \
		target/${CARGO_TARGET_NAME}/release/gix
}
