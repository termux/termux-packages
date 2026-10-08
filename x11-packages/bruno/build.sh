TERMUX_PKG_HOMEPAGE=https://www.usebruno.com
TERMUX_PKG_DESCRIPTION="Opensource API Client for Exploring and Testing APIs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="4.2.1"
TERMUX_PKG_SRCURL="https://github.com/usebruno/bruno/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f3e3f310f5d28baa95d55e4629595356df7500db66346d44406181070805bec3
TERMUX_PKG_DEPENDS="electron42, libx11"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_post_get_source() {
	# Upstream pins its own electron version, informational only
	local _electron_version
	_electron_version="$(jq -r '.devDependencies.electron // .dependencies.electron' \
		"$TERMUX_PKG_SRCDIR/packages/bruno-electron/package.json")"
	local _available_version
	_available_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"
	echo "Bruno was built/tested against Electron $_electron_version; this build uses $_available_version instead."
}

termux_step_make() {
	termux_setup_nodejs

	unset PREFIX prefix

	case "$TERMUX_ARCH" in
		"aarch64")
			export NPM_CONFIG_ARCH=arm64
			_electron_arch=arm64
		;;
		"arm")
			export NPM_CONFIG_ARCH=arm
			_electron_arch=armv7l
		;;
		"x86_64")
			export NPM_CONFIG_ARCH=x64
			_electron_arch=x64
		;;
		*)
			termux_error_exit "Unsupported arch: $TERMUX_ARCH"
		;;
	esac
	export npm_config_arch="$NPM_CONFIG_ARCH"

	# Rebuild native addons (@usebruno/sqlite) against electron headers
	export npm_config_nodedir="$TERMUX_PREFIX/opt/electron42-host-tools/node_headers"
	export CXX="$CXX -v -L$TERMUX_PREFIX/lib"

	# Skip electron binary download
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1

	npm ci

	# @lydell/node-pty has no android prebuild; use node-pty,
	# which npm builds from source against the electron headers set above
	npm install --workspace=packages/bruno-electron node-pty@1.1.0

	# Same order as upstream scripts/setup.js, bruno-app needs these built first
	npm run build --workspace=packages/bruno-graphql-docs
	npm run build --workspace=packages/bruno-query
	npm run build --workspace=packages/bruno-common
	npm run build --workspace=packages/bruno-converters
	npm run build --workspace=packages/bruno-requests
	npm run build --workspace=packages/bruno-schema-types
	npm run build --workspace=packages/bruno-filestore
	npm run build --workspace=packages/bruno-sqlite
	npm run sandbox:bundle-libraries --workspace=packages/bruno-js

	npm run build --workspace=packages/bruno-app

	# Bundle web build into bruno-electron
	bash scripts/build-electron.sh

	# Only app.asar is needed from electron-builder, so give it a
	# placeholder "electron" binary
	local _electron_dist_dir="$TERMUX_PKG_TMPDIR/electron-dist"
	rm -rf "$_electron_dist_dir"
	mkdir -p "$_electron_dist_dir"
	touch "$_electron_dist_dir/electron"
	chmod 0755 "$_electron_dist_dir/electron"

	local _electron_version
	_electron_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"

	(
		cd packages/bruno-electron
		npm exec electron-builder -- \
			--linux --"$_electron_arch" --dir \
			--config electron-builder-config.js \
			-c.electronDist="$_electron_dist_dir" \
			-c.electronVersion="$_electron_version" \
			-c.npmRebuild=false
	)
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find packages/bruno-electron/out -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under packages/bruno-electron/out"
	fi

	local dest="$TERMUX_PREFIX/opt/bruno"
	rm -rf "$dest"
	mkdir -p "$dest"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# Install the launcher shim. See: x11-packages/bruno/bruno-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/bruno-shim.sh" \
		> "$TERMUX_PREFIX/bin/bruno"
	chmod 0755 "$TERMUX_PREFIX/bin/bruno"

	install -Dm600 packages/bruno-electron/resources/icons/png/512x512.png \
		"$TERMUX_PREFIX/share/icons/hicolor/512x512/apps/bruno.png"

	cat > "$TERMUX_PREFIX/share/applications/bruno.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Bruno
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/bruno %U
	Icon=bruno
	Type=Application
	Categories=Development;
	StartupWMClass=Bruno
	MimeType=x-scheme-handler/bruno;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/bruno"
	fi
	EOF
}
