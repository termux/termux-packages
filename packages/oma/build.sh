TERMUX_PKG_HOMEPAGE=https://aosc.io/oma
TERMUX_PKG_DESCRIPTION="oma is an attempt at reworking APT's interface"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.24.1"
TERMUX_PKG_SRCURL="https://github.com/AOSC-Dev/oma/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5bd334f42e6104f5ecd959f84202db1a0ab99007a45003a9d5605522954153de
TERMUX_PKG_DEPENDS="libnettle, apt"
TERMUX_PKG_RECOMMENDS="ripgrep"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="v\d+\.\d+\.\d+(?!-)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
--features nice-setup
"

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' >> Cargo.toml

	# hardcoded upstream both /data/data/com.termux/files/usr and /data/data/com.termux/cache
	local original_name_component_one="com."
	local original_name_component_two="termux"
	local original_name="${original_name_component_one}${original_name_component_two}"
	if [[ "${original_name}" != "${TERMUX_APP__PACKAGE_NAME}" ]]; then
		find "$TERMUX_PKG_SRCDIR" -type f | \
			xargs -n 1 sed -i -e "s%${original_name}%${TERMUX_APP__PACKAGE_NAME}%g"
	fi

	# error: function-like macro '__GLIBC_USE' is not defined
	export BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME//-/_}="--sysroot ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot --target=${CARGO_TARGET_NAME}"
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/oma"
}
