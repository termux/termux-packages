TERMUX_PKG_HOMEPAGE=https://tauri.app
TERMUX_PKG_DESCRIPTION="Command line interface for building Tauri apps"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="
LICENSE_APACHE-2.0
LICENSE_MIT
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.0"
TERMUX_PKG_SRCURL="https://github.com/tauri-apps/tauri/archive/refs/tags/tauri-cli-v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=0687cf2580d0bc7cbada20b955643e8df6adcc0165d810286889ea402a3d5b78
# based on AUR package dependencies; watch AUR package for updates if necessary
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=tauri-cli
TERMUX_PKG_DEPENDS="curl, file, gtk3, libc++, librsvg, openssl, rust, webkit2gtk-4.1, wget"
TERMUX_PKG_UPDATE_VERSION_REGEXP="tauri-cli-v\d+.\d+.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor

	# prevent error:
	# sed: can't read ./crates/tauri-cli/templates/plugin/ios-xcode/tauri-plugin-{{: No such file or directory
	mv crates/tauri-cli/templates/     "$TERMUX_PKG_TMPDIR/tauri-cli-templates"
	mv vendor/cargo-mobile2/templates/ "$TERMUX_PKG_TMPDIR/cargo-mobile2-templates"
	mv vendor                          "$TERMUX_PKG_TMPDIR/vendor"
	mkdir -p vendor

	local crates=(
		tao
		wry
		muda
		rustls-platform-verifier
		cargo-mobile2
		tray-icon
	)
	local crate
	for crate in "${crates[@]}"; do
		find "$TERMUX_PKG_TMPDIR/vendor" \
			-mindepth 1 -maxdepth 1 -type d \
			-wholename "$TERMUX_PKG_TMPDIR/vendor/$crate" \
			-exec mv '{}' vendor/ \;
		sed -i "/\[patch.crates-io\]/a $crate = { path = \"./vendor/$crate\" }" Cargo.toml
	done

	find . -type f | xargs -n 1 sed -i \
		-e 's|\\"android\\"|\\"disabling_this_because_it_is_for_building_an_apk\\"|g' \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|\\"linux\\"|\\"android\\"|g' \
		-e 's|"linux"|"android"|g' \
		-e "s|/usr|$TERMUX_PREFIX|g" \
		-e "s|/tmp|$TERMUX_PREFIX/tmp|g"

	mv "$TERMUX_PKG_TMPDIR/tauri-cli-templates"     crates/tauri-cli/templates
	mv "$TERMUX_PKG_TMPDIR/cargo-mobile2-templates" vendor/cargo-mobile2/templates
	rm -rf "$TERMUX_PKG_TMPDIR/vendor"
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 "target/${CARGO_TARGET_NAME}/release/cargo-tauri" -t "$TERMUX_PREFIX/bin"
}
