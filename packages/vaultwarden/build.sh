TERMUX_PKG_HOMEPAGE=https://github.com/dani-garcia/vaultwarden
TERMUX_PKG_DESCRIPTION="Alternative implementation of the Bitwarden server API"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.37.5"
# Web-vault pin: latest stable bw_web_builds.
# The server reads the web version at runtime from web-vault/version.json,
# so there is no build-time coupling; bump this manually with the server.
_VW_WEB_VERSION=2026.10.1
TERMUX_PKG_SRCURL=(
  "https://github.com/dani-garcia/vaultwarden/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
  "https://github.com/dani-garcia/bw_web_builds/releases/download/v${_VW_WEB_VERSION}/bw_web_v${_VW_WEB_VERSION}.tar.gz"
)
TERMUX_PKG_SHA256=(
  6be37dcc95b91a058ecbe614f1a7acff68ca8d23dc2c016cec18517c7173e4cc
  354de9056c871e48db84975985e7d57c111ac6537bd4e4720488019e8638060f
)
TERMUX_PKG_DEPENDS="libsqlite, openssl"
TERMUX_PKG_SUGGESTS="vaultwarden-web-vault"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# Upstream build.rs requires at least one DB backend. `sqlite_system` links
# the system libsqlite instead of the bundled copy (libsqlite3-sys/bundled).
# System openssl is used instead of the `vendored_openssl` feature
# (atuin pattern below).
termux_step_pre_configure() {
	export OPENSSL_INCLUDE_DIR="$TERMUX_PREFIX/include"
	export OPENSSL_LIB_DIR="$TERMUX_PREFIX/lib"
	export OPENSSL_NO_VENDOR=1
	export SQLITE3_INCLUDE_DIR="$TERMUX_PREFIX/include"
	export SQLITE3_LIB_DIR="$TERMUX_PREFIX/lib"

	# psm (pulled in by pest_stack_guard on 1.37.5+) compiles host assembly
	# during the build; the target CFLAGS break the host compiler.
	# See: packages/atuin/build.sh
	unset CFLAGS
}

termux_step_make() {
	termux_setup_rust

	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" --release \
		--features sqlite_system
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/libexec" \
		"target/$CARGO_TARGET_NAME/release/vaultwarden"
	# The second source extracts as web-vault/ in the source root
	[ -f web-vault/index.html ] || termux_error_exit "web-vault/index.html missing"
	rm -rf "$TERMUX_PREFIX/share/vaultwarden/web-vault"
	mkdir -p "$TERMUX_PREFIX/share/vaultwarden"
	cp -r web-vault "$TERMUX_PREFIX/share/vaultwarden/web-vault"

	# Install the wrapper that pins Termux-sane defaults; the real binary
	# stays in $PREFIX/libexec. See: packages/vaultwarden/vaultwarden.sh
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		"$TERMUX_PKG_BUILDER_DIR/vaultwarden.sh" \
		> "$TERMUX_PREFIX/bin/vaultwarden"
	chmod 755 "$TERMUX_PREFIX/bin/vaultwarden"
}
