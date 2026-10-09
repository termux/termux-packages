TERMUX_PKG_HOMEPAGE=https://www.mongodb.com/products/tools/compass
TERMUX_PKG_DESCRIPTION="The GUI for MongoDB"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.52.0"
TERMUX_PKG_SRCURL="https://github.com/mongodb-js/compass/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=37fb95d5c50d32755349fd2ee3ea4122fcdaff4725e0a00a35c864c1e0cb8a33
TERMUX_PKG_DEPENDS="electron42, krb5, libx11"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_post_get_source() {
	# informational only
	local _electron_version
	_electron_version="$(jq -r '.devDependencies.electron' \
		"$TERMUX_PKG_SRCDIR/packages/compass/package.json")"
	local _available_version
	_available_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"
	echo "Compass was built/tested against Electron $_electron_version; this build uses $_available_version instead."
}

termux_step_make() {
	termux_setup_nodejs

	unset PREFIX prefix

	case "$TERMUX_ARCH" in
		"aarch64")
			export NPM_CONFIG_ARCH=arm64
		;;
		"arm")
			export NPM_CONFIG_ARCH=arm
		;;
		"x86_64")
			export NPM_CONFIG_ARCH=x64
		;;
		*)
			termux_error_exit "Unsupported arch: $TERMUX_ARCH"
		;;
	esac
	export npm_config_arch="$NPM_CONFIG_ARCH"

	# prebuilt addons are glibc-only, build from source
	export npm_config_nodedir="$TERMUX_PREFIX/opt/electron42-host-tools/node_headers"
	export npm_config_build_from_source=true
	export CXX="$CXX -v -L$TERMUX_PREFIX/lib"

	# webpack needs a big heap
	export NODE_OPTIONS="$NODE_OPTIONS --max-old-space-size=8192"

	# webpack config requires "electron", which downloads a binary (no armv7l)
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	export ELECTRON_OVERRIDE_DIST_PATH="$TERMUX_PKG_TMPDIR/electron-dist"

	# skip install hooks (they download a glibc-only CSFLE library)
	npm ci --ignore-scripts

	# compile workspace dependencies of mongodb-compass
	npm exec -- lerna run bootstrap \
		--scope mongodb-compass --include-dependencies --stream

	# normally done by the skipped install hook
	(cd packages/compass && node scripts/download-fonts.js)

	# webpack must resolve cpufeatures.node; optional for ssh2, so use a placeholder on failure
	npm rebuild cpu-features --foreground-scripts || \
		echo "WARNING: failed to build optional native module cpu-features"
	if [[ ! -e node_modules/cpu-features/build/Release/cpufeatures.node ]]; then
		mkdir -p node_modules/cpu-features/build/Release
		touch node_modules/cpu-features/build/Release/cpufeatures.node
	fi

	# upstream "compile" without the SBOM notices step
	HADRON_DISTRIBUTION=compass \
		npm run webpack --workspace=mongodb-compass -- --mode production

	# assemble the app like hadron-build
	local _app_dir="$TERMUX_PKG_TMPDIR/app"
	rm -rf "$_app_dir"
	mkdir -p "$_app_dir"
	cp -r packages/compass/build "$_app_dir/build"
	cp LICENSE "$_app_dir/LICENSE"

	node "$TERMUX_PKG_BUILDER_DIR/transform-package-json.js" "$_app_dir/package.json"

	(
		cd "$_app_dir"
		npm install --omit=dev --ignore-scripts --no-package-lock

		# optional at runtime (src/main/optional-deps.ts)
		local _module
		for _module in \
			interruptor \
			kerberos \
			os-dns-native \
			@mongodb-js/native-machine-id \
			mongodb-client-encryption; do
			npm rebuild "$_module" --foreground-scripts || \
				echo "WARNING: failed to build optional native module $_module"
		done

		find . -name node_gyp_bins -prune -exec rm -rf {} +
		find . -type d -path "*/Release/obj*" -prune -exec rm -rf {} +
	)

	local _unpack
	_unpack="$(jq -r '(["*.node", "**/vendor/**"] + .config.hadron.asar.unpack) | "{" + join(",") + "}"' \
		"$_app_dir/package.json")"

	# asar globs skip dot dirs in the path (~/.termux-build), pack from /tmp
	local _pack_dir
	_pack_dir="$(mktemp -d /tmp/mongodb-compass.XXXXXX)"
	mv "$_app_dir" "$_pack_dir/app"
	npm exec --workspace=hadron-build -- asar pack \
		"$_pack_dir/app" "$_pack_dir/app.asar" --unpack "$_unpack"
	mv "$_pack_dir"/app.asar* "$TERMUX_PKG_TMPDIR/"
	rm -rf "$_pack_dir"
}

termux_step_make_install() {
	if [[ ! -e "$TERMUX_PKG_TMPDIR/app.asar" ]]; then
		termux_error_exit "app.asar not found in $TERMUX_PKG_TMPDIR"
	fi

	local dest="$TERMUX_PREFIX/opt/mongodb-compass"
	rm -rf "$dest"
	mkdir -p "$dest/resources"
	cp -r "$TERMUX_PKG_TMPDIR"/app.asar* "$dest/resources/"

	# Install the launcher shim. See: x11-packages/mongodb-compass/mongodb-compass-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/mongodb-compass-shim.sh" \
		> "$TERMUX_PREFIX/bin/mongodb-compass"
	chmod 0755 "$TERMUX_PREFIX/bin/mongodb-compass"

	install -Dm600 packages/compass/app-icons/linux/mongodb-compass-logo-stable.png \
		"$TERMUX_PREFIX/share/icons/hicolor/276x276/apps/mongodb-compass.png"

	cat > "$TERMUX_PREFIX/share/applications/mongodb-compass.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=MongoDB Compass
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/mongodb-compass %U
	Icon=mongodb-compass
	Type=Application
	Categories=Development;Database;
	StartupWMClass=MongoDB Compass
	MimeType=x-scheme-handler/mongodb;x-scheme-handler/mongodb+srv;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/mongodb-compass"
	fi
	EOF
}
