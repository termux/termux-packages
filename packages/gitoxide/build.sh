TERMUX_PKG_HOMEPAGE=https://github.com/Byron/gitoxide
TERMUX_PKG_DESCRIPTION="Rust implementation of Git"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-APACHE, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.50.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/Byron/gitoxide/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8ad0fdcfa465fedac7c4bafaae2349ad0db7daf48a80d9cb2bd70dd36fa567aa
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/aws-lc-sys \
		! -wholename ./vendor/hickory-resolver \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/aws-lc-sys.diff"
	local dir="vendor/aws-lc-sys"
	echo "Applying patch: $patch"
	patch --silent -p1 -d "${dir}" < "$patch"

	patch="$TERMUX_PKG_BUILDER_DIR/hickory-resolver.diff"
	dir="vendor/hickory-resolver"
	echo "Applying patch: $patch"
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
		"$patch" | patch --silent -p1 -d "${dir}"

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'aws-lc-sys = { path = "./vendor/aws-lc-sys" }' >> Cargo.toml
	echo 'hickory-resolver = { path = "./vendor/hickory-resolver" }' >> Cargo.toml
	echo 'rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' >> Cargo.toml

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
