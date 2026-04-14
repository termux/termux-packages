TERMUX_PKG_HOMEPAGE=https://garagehq.deuxfleurs.fr/
TERMUX_PKG_DESCRIPTION="S3-compatible object store for small self-hosted geo-distributed deployments"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL=https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e68b05d4358008e8b29a0ac235f73e3a12d97d9c6388c330b87282db774c04dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/garage.toml"
TERMUX_PKG_DEPENDS="openssl-tool"

termux_step_make() {
	termux_setup_rust
	cargo build --package garage --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/garage"
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/garage.toml" "$TERMUX_PREFIX/share/garage/garage.toml.in"
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		if [ -e "$TERMUX_PREFIX/etc/garage.toml" ]; then
			exit 0
		fi

		echo "[*] Generating default configuration file at $TERMUX_PREFIX/etc/garage.toml"

		mkdir -p "$TERMUX_PREFIX/etc"

		rpc_secret=\$(openssl rand -hex 32)
		admin_token=\$(openssl rand -hex 32)
		metrics_token=\$(openssl rand -hex 32)

		awk \
			-v prefix="$TERMUX_PREFIX" \
			-v rpc_secret="\$rpc_secret" \
			-v admin_token="\$admin_token" \
			-v metrics_token="\$metrics_token" '
				{
					gsub(/@TERMUX_PREFIX@/, prefix)
					gsub(/@GARAGE_RPC_SECRET@/, rpc_secret)
					gsub(/@GARAGE_ADMIN_TOKEN@/, admin_token)
					gsub(/@GARAGE_METRICS_TOKEN@/, metrics_token)
					print
				}
			' "$TERMUX_PREFIX/share/garage/garage.toml.in" > "$TERMUX_PREFIX/etc/garage.toml"
		chmod 0600 "$TERMUX_PREFIX/etc/garage.toml"

		exit 0
	EOF

	chmod 0755 ./postinst
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/lib/garage/meta"
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/var/lib/garage/data"
}
