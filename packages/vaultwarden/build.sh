TERMUX_PKG_HOMEPAGE=https://github.com/dani-garcia/vaultwarden
TERMUX_PKG_DESCRIPTION="Alternative implementation of the Bitwarden server API"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.37.4"
# Web-vault pin: latest stable bw_web_builds (v2026.8.0 is a prerelease).
# The server reads the web version at runtime from web-vault/version.json,
# so there is no build-time coupling; bump this manually with the server.
_VW_WEB_VERSION=2026.7.0
TERMUX_PKG_SRCURL=(
  "https://github.com/dani-garcia/vaultwarden/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
  "https://github.com/dani-garcia/bw_web_builds/releases/download/v${_VW_WEB_VERSION}/bw_web_v${_VW_WEB_VERSION}.tar.gz"
)
TERMUX_PKG_SHA256=(
  d31a3ef5456619cfe424f0586f4ecadd186e22513a93bbeab6bc2f09cda803a7
  002e972bf0d0487ec0324b06d916de33e29de4c29bffd92ee3b843084c300570
)
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_SUGGESTS="vaultwarden-web-vault"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# Upstream build.rs requires at least one DB backend; `sqlite` statically
# links its own sqlite (libsqlite3-sys/bundled), so no system sqlite
# dependency is needed at runtime. System openssl is used instead of the
# `vendored_openssl` feature (atuin pattern below).
termux_step_pre_configure() {
	export OPENSSL_INCLUDE_DIR="$TERMUX_PREFIX/include"
	export OPENSSL_LIB_DIR="$TERMUX_PREFIX/lib"
	export OPENSSL_NO_VENDOR=1
}

termux_step_make() {
	termux_setup_rust

	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" --release \
		--features sqlite
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/libexec" \
		"target/$CARGO_TARGET_NAME/release/vaultwarden"
	# The second source extracts as web-vault/ in the source root
	[ -f web-vault/index.html ] || termux_error_exit "web-vault/index.html missing"
	rm -rf "$TERMUX_PREFIX/share/vaultwarden/web-vault"
	mkdir -p "$TERMUX_PREFIX/share/vaultwarden"
	cp -r web-vault "$TERMUX_PREFIX/share/vaultwarden/web-vault"

	# Upstream DATA_FOLDER defaults to CWD-relative ./data (src/config.rs),
	# which scatters state depending on where you start it from. The wrapper
	# pins Termux-sane defaults; every one remains overridable via
	# environment. Rocket's own default port 8000 binds unprivileged, so
	# ROCKET_PORT is left alone (only Docker defaults it to 80).
	cat >"$TERMUX_PREFIX/bin/vaultwarden" <<EOF
#!/bin/sh
DATA_DIR="\${DATA_FOLDER:-$TERMUX_PREFIX/var/lib/vaultwarden}"
mkdir -p "\$DATA_DIR"
export DATA_FOLDER="\$DATA_DIR"
WEB_VAULT_FOLDER="\${WEB_VAULT_FOLDER:-$TERMUX_PREFIX/share/vaultwarden/web-vault}"
export WEB_VAULT_FOLDER
# The web UI lives in the vaultwarden-web-vault subpackage: enable it by
# default only when present, since upstream exit(1)s when enabled with
# the folder absent (src/main.rs). Explicit WEB_VAULT_ENABLED wins.
if [ -z "\${WEB_VAULT_ENABLED:-}" ]; then
	if [ -f "\$WEB_VAULT_FOLDER/index.html" ]; then
		WEB_VAULT_ENABLED=true
	else
		WEB_VAULT_ENABLED=false
	fi
fi
export WEB_VAULT_ENABLED
exec "$TERMUX_PREFIX/libexec/vaultwarden" "\$@"
EOF
	chmod 755 "$TERMUX_PREFIX/bin/vaultwarden"
}
