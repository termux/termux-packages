TERMUX_PKG_HOMEPAGE=https://github.com/ProtonDriveApps/sdk
TERMUX_PKG_DESCRIPTION="Official command-line client for Proton Drive"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL="https://github.com/ProtonDriveApps/sdk/archive/refs/tags/cli/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8963fd2e6d20b637cee17c9e6d76bd5cb92412035e9208359046e4deb0f67f44
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="^cli/v\K[0-9]+\.[0-9]+\.[0-9]+$"
TERMUX_PKG_DEPENDS="bun"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_bun

	(cd client/js && bun install)
	(cd incubating/account/js && bun install)

	cd cli
	bun install
	CLI_APP_VERSION_NAME="cli-drive-termux" \
	CLI_VERSION="$TERMUX_PKG_VERSION" \
		bun run build:bundle
}

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	install -d "$TERMUX_PREFIX/lib/proton-drive-cli"
	install -Dm644 cli/release/proton-drive.js \
		"$TERMUX_PREFIX/lib/proton-drive-cli/proton-drive.js"

	cat > "$TERMUX_PREFIX/bin/proton-drive" <<-EOF
	#!${TERMUX_PREFIX}/bin/sh
	exec bun "${TERMUX_PREFIX}/lib/proton-drive-cli/proton-drive.js" "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/proton-drive"
}
