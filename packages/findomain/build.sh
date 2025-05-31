TERMUX_PKG_HOMEPAGE=https://findomain.app/
TERMUX_PKG_DESCRIPTION="Findomain is the fastest subdomain enumerator and the only one written in Rust"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.0.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/Findomain/Findomain/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=98c142e2e6ed67726bdea7a1726a54fb6773a8d1ccaa262e008804432af29190
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	# ld: error: undefined symbol: __atomic_is_lock_free
	# ld: error: undefined symbol: __atomic_fetch_or_8
	# ld: error: undefined symbol: __atomic_load
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)"
	fi

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

	git clone https://github.com/Findomain/trust-dns \
		-b custombranch \
		./vendor/trust-dns

	patch --silent -p1 \
		-d ./vendor/trust-dns/crates/resolver/ \
		< "$TERMUX_PKG_BUILDER_DIR"/trust-dns-resolver.diff

	patch --silent -p1 \
		-d "$TERMUX_PKG_SRCDIR" \
		< "$TERMUX_PKG_BUILDER_DIR"/patch-root-Cargo.diff

	# clash with rust host build
	unset CFLAGS
}
