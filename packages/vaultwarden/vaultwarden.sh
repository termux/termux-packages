#!/usr/bin/env sh

# Upstream DATA_FOLDER defaults to a CWD-relative ./data (src/config.rs),
# which scatters state depending on where the server is started from.
# Pin Termux-sane defaults; each one remains overridable via the environment.
DATA_DIR="${DATA_FOLDER:-@TERMUX_PREFIX@/var/lib/vaultwarden}"
mkdir -p "$DATA_DIR"
export DATA_FOLDER="$DATA_DIR"

# Upstream exits when the web vault is enabled but its folder is missing
# (src/main.rs). The UI ships in the vaultwarden-web-vault subpackage, so
# enable it by default only when present; explicit WEB_VAULT_ENABLED wins.
WEB_VAULT_FOLDER="${WEB_VAULT_FOLDER:-@TERMUX_PREFIX@/share/vaultwarden/web-vault}"
export WEB_VAULT_FOLDER
if [ -z "${WEB_VAULT_ENABLED:-}" ]; then
	if [ -f "$WEB_VAULT_FOLDER/index.html" ]; then
		WEB_VAULT_ENABLED=true
	else
		WEB_VAULT_ENABLED=false
	fi
fi
export WEB_VAULT_ENABLED

# Rocket's default port 8000 is unprivileged, so ROCKET_PORT is left alone
# (only the upstream Docker image defaults it to 80).
exec "@TERMUX_PREFIX@/libexec/vaultwarden" "$@"
