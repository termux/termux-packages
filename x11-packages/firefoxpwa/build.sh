TERMUX_PKG_HOMEPAGE=https://pwasforfirefox.filips.si/
TERMUX_PKG_DESCRIPTION="PWAs for Firefox"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.1"
TERMUX_PKG_SRCURL=https://github.com/filips123/PWAsForFirefox/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=40d2f4987e473a312947829e1ac57b58d2c322250c335aa1e148a75c9c40aa74
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

	cargo build --release --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {

	cd native

	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/firefoxpwa"
	install -Dm755 -t "$TERMUX_PREFIX/libexec" "target/${CARGO_TARGET_NAME}/release/firefoxpwa-connector"
	# manifest
	install -DTm644 manifests/termux.json "$TERMUX_PREFIX/lib/mozilla/native-messaging-hosts/firefoxpwa.json"
	# completions
	install -Dm644 -t "$TERMUX_PREFIX/share/bash-completion/completions" "target/${CARGO_TARGET_NAME}/release/completions/firefoxpwa.bash"
	install -Dm644 -t "$TERMUX_PREFIX/share/fish/vendor_completions.d" "target/${CARGO_TARGET_NAME}/release/completions/firefoxpwa.fish"
	install -Dm644 -t "$TERMUX_PREFIX/share/zsh/vendor-completions" "target/${CARGO_TARGET_NAME}/release/completions/_firefoxpwa"
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

termux_step_create_debscipts() {
	cat <<-EOF >./postinst
		#!${TERMUX_PREFIX}/bin/sh
		firefoxpwa runtime install --link
		exit 0
	EOF
	cat <<-EOF >./prerm
		#!${TERMUX_PREFIX}/bin/sh
		firefoxpwa runtime uninstall
		exit 0
	EOF
	chmod +x ./postinst ./prerm

}
