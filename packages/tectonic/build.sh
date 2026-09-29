TERMUX_PKG_HOMEPAGE=https://tectonic-typesetting.github.io/
TERMUX_PKG_DESCRIPTION="A modernized, complete, self-contained TeX/LaTeX engine"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/tectonic-typesetting/tectonic/archive/refs/tags/tectonic@${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=30adda98f67dd5389844f6023adeeb54b5475c17a54b777900644468fbc9765d
TERMUX_PKG_DEPENDS="fontconfig, freetype, harfbuzz, libc++, libgraphite, libicu, libpng, openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

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
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features "external-harfbuzz"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/tectonic
}
