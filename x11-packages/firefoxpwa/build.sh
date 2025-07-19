TERMUX_PKG_HOMEPAGE=https://pwasforfirefox.filips.si/
TERMUX_PKG_DESCRIPTION="A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox (native component)"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.15.0"
TERMUX_PKG_SRCURL="https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=772ef9461aaed98f90f772f8e01070272048f7607ac061b56f1af4ab5f8bbade
TERMUX_PKG_DEPENDS="firefox"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_make() {
	cd native
	termux_setup_rust
	# Set the correct version in source files
	sed -i "s/version = \"0.0.0\"/version = \"${TERMUX_PKG_VERSION}\"/g" Cargo.toml
	sed -i "s/DISTRIBUTION_VERSION = '0.0.0'/DISTRIBUTION_VERSION = '${TERMUX_PKG_VERSION}'/g" userchrome/profile/chrome/pwa/chrome.sys.mjs

	local release_arg="--release"
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		release_arg=""
	fi

	cargo build $release_arg --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {
	cd native

	local build_dir="target/${CARGO_TARGET_NAME}/release"
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		build_dir="target/${CARGO_TARGET_NAME}/debug"
	fi

	install -Dm755 -t "$TERMUX_PREFIX/bin" "$build_dir/firefoxpwa"
	install -Dm755 -t "$TERMUX_PREFIX/libexec" "$build_dir/firefoxpwa-connector"
	# manifest
	install -DTm644 manifests/termux.json "$TERMUX_PREFIX/lib/mozilla/native-messaging-hosts/firefoxpwa.json"
	# completions
	install -Dm644 -t "$TERMUX_PREFIX/share/bash-completion/completions" "$build_dir/completions/firefoxpwa.bash"
	install -Dm644 -t "$TERMUX_PREFIX/share/fish/vendor_completions.d" "$build_dir/completions/firefoxpwa.fish"
	install -Dm644 -t "$TERMUX_PREFIX/share/zsh/vendor-completions" "$build_dir/completions/_firefoxpwa"
	# UserChrome
	install -dm755 "$TERMUX_PREFIX/share/firefoxpwa/userchrome"
	cp -r userchrome/* "$TERMUX_PREFIX/share/firefoxpwa/userchrome/"
	# Documentation
	install -DTm644 ../README.md "$TERMUX_PREFIX/share/doc/firefoxpwa/README.md"
	install -DTm644 ../native/README.md "$TERMUX_PREFIX/share/doc/firefoxpwa/README-NATIVE.md"
	install -DTm644 ../extension/README.md "$TERMUX_PREFIX/share/doc/firefoxpwa/README-EXTENSION.md"
	# AppStream Metadata
	install -Dm644 -t "$TERMUX_PREFIX/share/metainfo" "packages/appstream/si.filips.FirefoxPWA.metainfo.xml"
	install -Dm644 -t "$TERMUX_PREFIX/share/icons/hicolor/scalable/apps" "packages/appstream/si.filips.FirefoxPWA.svg"
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		firefoxpwa runtime install --link
		exit 0
	EOF
	cat <<-EOF > ./prerm
		#!${TERMUX_PREFIX}/bin/sh
		firefoxpwa runtime uninstall
		exit 0
	EOF
	chmod +x ./postinst ./prerm
}
