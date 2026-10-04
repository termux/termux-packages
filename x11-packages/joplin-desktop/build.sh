TERMUX_PKG_HOMEPAGE=https://joplinapp.org
TERMUX_PKG_DESCRIPTION="Open source note taking and to-do application with synchronisation (desktop app)"
TERMUX_PKG_LICENSE="AGPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.7.21"
TERMUX_PKG_SRCURL="https://github.com/laurent22/joplin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d868a2f9a48937c514b6b39486e88f473b4477085035f75d22542800c1fdd083
TERMUX_PKG_DEPENDS="7zip, electron42, libnotify, libsecret, libx11"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers, glib, pkg-config"
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
		"$TERMUX_PKG_SRCDIR/packages/app-desktop/package.json")"
	local _available_version
	_available_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"
	echo "Joplin was built/tested against Electron $_electron_version; this build uses $_available_version instead."

	# Skip root postinstall, it builds the whole monorepo
	jq 'del(.scripts.postinstall)' package.json > package.json.tmp
	mv package.json.tmp package.json

	# AppImage/macOS-only hooks
	jq 'del(.build.afterAllArtifactBuild, .build.afterSign)' \
		packages/app-desktop/package.json > packages/app-desktop/package.json.tmp
	mv packages/app-desktop/package.json.tmp packages/app-desktop/package.json
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
	# Used by Joplin's copy7Zip and cleanOnnxRuntime gulp tasks
	export npm_config_target_arch="$NPM_CONFIG_ARCH"
	# node-pre-gyp puts sqlite3's binding in lib/binding/napi-v6-linux-<libc>-<arch>.
	# detect-libc reports "glibc" on the build host but nothing on Termux (bionic),
	# so at runtime sqlite3 looks in the "unknown" directory. Force it at build time.
	export npm_config_target_libc=unknown

	# Build native addons from source, glibc prebuilts don't work
	export npm_config_nodedir="$TERMUX_PREFIX/opt/electron42-host-tools/node_headers"
	export npm_config_build_from_source=true
	export CXX="$CXX -v -L$TERMUX_PREFIX/lib"

	# Skip electron binary download
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	# Disable husky git hooks
	export HUSKY=0
	# OneNote importer needs Rust + wasm-pack, skip
	export SKIP_ONENOTE_CONVERTER_BUILD=1

	local _yarn_release
	_yarn_release="$(echo "$TERMUX_PKG_SRCDIR"/.yarn/releases/yarn-*.cjs)"
	_yarn() { node "$_yarn_release" "$@"; }

	# Scripts disabled (sharp fails to build); sqlite3/keytar built below.
	# Root workspace included for glob, @types/fs-extra, etc.
	YARN_ENABLE_SCRIPTS=false _yarn workspaces focus root @joplin/app-desktop

	(
		cd packages/app-desktop
		export PATH="$PWD/node_modules/.bin:$PATH"
		for _module in sqlite3 keytar; do
			(cd "node_modules/$_module" && npm run install --foreground-scripts)
		done
	)

	# onenote-converter excluded (needs Rust, undeclared deps)
	_yarn workspaces foreach --recursive --topological-dev \
		--from @joplin/app-desktop --exclude @joplin/onenote-converter \
		--verbose --interlaced run build
	_yarn workspaces foreach --recursive --topological-dev \
		--from @joplin/app-desktop --exclude @joplin/onenote-converter \
		--verbose --interlaced run tsc

	(
		cd packages/app-desktop

		# Upstream "yarn dist" without rebuild/packaging
		_yarn run gulp before-dist

		# Placeholder electron binary, only app.asar is needed
		local _electron_dist_dir="$TERMUX_PKG_TMPDIR/electron-dist"
		rm -rf "$_electron_dist_dir"
		mkdir -p "$_electron_dist_dir"
		touch "$_electron_dist_dir/electron"
		chmod 0755 "$_electron_dist_dir/electron"

		local _electron_version
		_electron_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"

		_yarn exec electron-builder \
			--linux --"$_electron_arch" --dir \
			-c.electronDist="$_electron_dist_dir" \
			-c.electronVersion="$_electron_version" \
			-c.npmRebuild=false
	)
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find packages/app-desktop/dist -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under packages/app-desktop/dist"
	fi

	# sqlite3 must have its binding in the "unknown" libc dir, which is what
	# node-pre-gyp resolves on Termux at runtime.
	if ! find "$_dist_dir/resources/app.asar.unpacked/node_modules/sqlite3/lib/binding" \
		-path '*-linux-unknown-*' -name node_sqlite3.node 2>/dev/null | grep -q .; then
		termux_error_exit "sqlite3 binding not found in a linux-unknown-<arch> directory"
	fi

	local dest="$TERMUX_PREFIX/opt/joplin-desktop"
	rm -rf "$dest"
	mkdir -p "$dest"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# glibc/x86_64 sqlite-vec binary, unusable (vector search disabled)
	rm -rf "$dest"/resources/app.asar.unpacked/node_modules/sqlite-vec-*

	# Bundled 7za is glibc, wrap Termux's 7za instead
	local _7za="$dest/resources/7zip/7za"
	if [[ -e "$_7za" ]]; then
		rm -f "$_7za"
		cat > "$_7za" <<-SEVENZIP
		#!$TERMUX_PREFIX/bin/sh
		exec "$TERMUX_PREFIX/bin/7za" "\$@"
		SEVENZIP
		chmod 0755 "$_7za"
	fi

	# Install the launcher shim. See: x11-packages/joplin-desktop/joplin-desktop-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/joplin-desktop-shim.sh" \
		> "$TERMUX_PREFIX/bin/joplin-desktop"
	chmod 0755 "$TERMUX_PREFIX/bin/joplin-desktop"

	install -Dm600 Assets/LinuxIcons/512x512.png \
		"$TERMUX_PREFIX/share/icons/hicolor/512x512/apps/joplin.png"

	cat > "$TERMUX_PREFIX/share/applications/joplin-desktop.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Joplin
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/joplin-desktop %U
	Icon=joplin
	Type=Application
	Categories=Office;
	StartupWMClass=appimagekit-joplin
	MimeType=x-scheme-handler/joplin;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/joplin-desktop"
	fi
	EOF
}
