TERMUX_PKG_HOMEPAGE=https://github.com/hatoo/oha
TERMUX_PKG_DESCRIPTION="HTTP load generator with realtime tui, inspired by rakyll/hey"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=1.16.0
TERMUX_PKG_SRCURL="https://github.com/hatoo/oha/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8d856e2850efb521c0a1f8efed530eeaeebea34d09c6edc19a42dc5e13b14287
TERMUX_PKG_DEPENDS="resolv-conf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# default TLS backend (rustls) pulls in aws-lc-sys, which needs cmake
	termux_setup_cmake
	termux_setup_rust

	# hickory-resolver's android backend queries the system DNS servers
	# through JNI/ndk-context, which requires a live Android Activity
	# context. Plain Termux CLI binaries never initialize that context,
	# so at runtime it panics with "android context was not initialized".
	# Force it to use the generic unix resolv.conf backend instead, same
	# fix as used in cargo-binstall/dumbpipe/sendme/gitoxide.
	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/hickory-resolver \
		-exec rm -rf '{}' \;

	find vendor/hickory-resolver -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e "s|/etc/resolv.conf|$TERMUX_PREFIX/etc/resolv.conf|g"

	cat >> Cargo.toml <<-EOF

		[patch.crates-io]
		hickory-resolver = { path = "./vendor/hickory-resolver" }
	EOF
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/${CARGO_TARGET_NAME}/release/oha" \
		"$TERMUX_PREFIX/bin/oha"
}
