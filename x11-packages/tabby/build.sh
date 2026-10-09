TERMUX_PKG_HOMEPAGE=https://tabby.sh
TERMUX_PKG_DESCRIPTION="A highly configurable terminal emulator, SSH and serial client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.0.237"
TERMUX_PKG_SRCURL="https://github.com/Eugeny/tabby/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=829488cbc42921d60e88a862c1fbce6ba52d953a803da838657878b8de975b6b
TERMUX_PKG_DEPENDS="electron42, fontconfig-utils, libsecret, libx11, procps"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true

# The npm "russh" package has no android binary, so its Rust addon (russh-napi)
# is built from source. Both pins are rewritten by termux_pkg_auto_update().
_RUSSH_NAPI_COMMIT=e61c5444e6128211ba028e252948cc8da9ea2235
_RUSSH_NAPI_SHA256=c0fcfe4d49b098359f8ac9786d69b60f35380e0f51d05b28df631c22f00d60be

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(termux_github_api_get_tag)"
	[[ -n "${latest_tag}" ]] || termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	latest_tag="${latest_tag#v}"
	[[ "${latest_tag}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
		termux_error_exit "Unexpected Tabby tag '${latest_tag}'"

	# Only rewrite the pins when an update will really happen.
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${latest_tag}" &&
		[[ "${BUILD_PACKAGES}" != "false" && -z "${TERMUX_PKG_UPGRADE_VERSION_DRY_RUN:-}" ]]; then
		__tabby_resolve_russh_napi_pin "${latest_tag}"
		sed \
			-e "s/^\(_RUSSH_NAPI_COMMIT=\).*/\1${_NEW_RUSSH_NAPI_COMMIT}/" \
			-e "s/^\(_RUSSH_NAPI_SHA256=\).*/\1${_NEW_RUSSH_NAPI_SHA256}/" \
			-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"
	fi

	termux_pkg_upgrade_version "${latest_tag}"
}

# Finds the russh-napi commit (no tags upstream) whose package.json version is
# "<npm version>+<russh version>" for the given tabby release, and its checksum.
# Sets _NEW_RUSSH_NAPI_COMMIT and _NEW_RUSSH_NAPI_SHA256.
__tabby_resolve_russh_napi_pin() {
	local version="$1"
	local napi_repo="https://github.com/Eugeny/russh-napi"

	local russh_version
	russh_version="$(curl -fsSL \
		"https://raw.githubusercontent.com/Eugeny/tabby/v${version}/app/package.json" |
		jq -r '.dependencies.russh // empty')"
	[[ "${russh_version}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
		termux_error_exit "Could not read the russh version of tabby ${version} (got '${russh_version}')"

	local clone_dir
	clone_dir="$(mktemp -d)"
	git clone --quiet --bare --filter=blob:none "${napi_repo}.git" "${clone_dir}" ||
		termux_error_exit "Failed to clone russh-napi"

	local commit candidate=""
	# Oldest first, the first commit with the version is the release commit.
	for commit in $(git -C "${clone_dir}" log --reverse --format=%H -- package.json); do
		if [[ "$(git -C "${clone_dir}" show "${commit}:package.json" | jq -r '.version')" == "${russh_version}+"* ]]; then
			candidate="${commit}"
			break
		fi
	done
	if [[ -z "${candidate}" ]] || ! git -C "${clone_dir}" cat-file -e "${candidate}:Cargo.lock"; then
		rm -rf "${clone_dir}"
		termux_error_exit "No russh-napi commit with a Cargo.lock found for russh ${russh_version} (tabby ${version})"
	fi
	rm -rf "${clone_dir}"
	_NEW_RUSSH_NAPI_COMMIT="${candidate}"

	_NEW_RUSSH_NAPI_SHA256="$(curl -fsSL "${napi_repo}/archive/${_NEW_RUSSH_NAPI_COMMIT}.tar.gz" | sha256sum | cut -d' ' -f1)"
	[[ "${_NEW_RUSSH_NAPI_SHA256}" =~ ^[0-9a-f]{64}$ ]] ||
		termux_error_exit "Failed to compute the checksum of russh-napi ${_NEW_RUSSH_NAPI_COMMIT}"
}

termux_step_post_get_source() {
	# Upstream pins its own electron version, informational only
	local _electron_version
	_electron_version="$(jq -r '.devDependencies.electron // .dependencies.electron' \
		"$TERMUX_PKG_SRCDIR/package.json")"
	local _available_version
	_available_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"
	echo "Tabby was built/tested against Electron $_electron_version; this build uses $_available_version instead."

	local _russh_tarball="$TERMUX_PKG_CACHEDIR/russh-napi-${_RUSSH_NAPI_COMMIT}.tar.gz"
	termux_download \
		"https://github.com/Eugeny/russh-napi/archive/${_RUSSH_NAPI_COMMIT}.tar.gz" \
		"$_russh_tarball" \
		"$_RUSSH_NAPI_SHA256"
	rm -rf "$TERMUX_PKG_SRCDIR/russh-napi-src"
	mkdir -p "$TERMUX_PKG_SRCDIR/russh-napi-src"
	tar -xf "$_russh_tarball" -C "$TERMUX_PKG_SRCDIR/russh-napi-src" --strip-components=1

	# The pinned rust toolchain is not available in Termux
	rm -f "$TERMUX_PKG_SRCDIR/russh-napi-src/rust-toolchain.toml"

	local _russh_wanted _russh_napi_version
	_russh_wanted="$(jq -r '.dependencies.russh' "$TERMUX_PKG_SRCDIR/app/package.json")"
	_russh_napi_version="$(jq -r '.version' "$TERMUX_PKG_SRCDIR/russh-napi-src/package.json")"
	if [[ "${_russh_napi_version%%+*}" != "$_russh_wanted" ]]; then
		termux_error_exit "russh-napi is $_russh_napi_version but tabby wants russh $_russh_wanted, bump _RUSSH_NAPI_COMMIT"
	fi
}

termux_step_make() {
	termux_setup_nodejs
	termux_setup_rust

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
	# Used by Tabby's own build scripts (scripts/vars.mjs)
	export ARCH="$_electron_arch"
	export TABBY_VERSION="$TERMUX_PKG_VERSION"
	# Native modules are built once, against the electron headers set below
	export TABBY_SKIP_NATIVE_REBUILD=1

	# Build native addons (node-pty, keytar) against the electron headers.
	# The build host is Linux, so without this node-pty and keytar would pick
	# their prebuilt glibc binaries instead of compiling for Android.
	export npm_config_nodedir="$TERMUX_PREFIX/opt/electron42-host-tools/node_headers"
	export npm_config_build_from_source=true
	export CXX="$CXX -L$TERMUX_PREFIX/lib"

	# Skip electron binary download
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1

	# Tabby uses yarn 1 and recent node-gyp, yarn's bundled node-gyp is too old
	local _tools="$TERMUX_PKG_TMPDIR/tools"
	rm -rf "$_tools"
	mkdir -p "$_tools"
	npm install --prefix "$_tools" yarn@1.22.22 node-gyp@13
	export PATH="$_tools/node_modules/.bin:$PATH"
	export npm_config_node_gyp="$_tools/node_modules/node-gyp/bin/node-gyp.js"

	# node-pty from the beta line has no android build, use the same
	# version as code-oss, which is known to build from source in Termux
	local _app_pkg
	_app_pkg="$(jq '.dependencies["node-pty"] = "1.1.0"' app/package.json)"
	echo "$_app_pkg" > app/package.json

	# electron-builder only needs a placeholder binary, see below
	sed -i '/^electronFuses:/,$d' electron-builder.yml

	# Same steps as the "postinstall" script in the root package.json,
	# done by hand so that every native build gets the environment above
	yarn install --ignore-scripts --network-timeout 1000000
	yarn patch-package
	node scripts/install-deps.mjs

	# Native addons without a build for android:
	# - native-process-working-directory reads /proc/<pid>/cwd on linux only
	sed -i "s/process.platform === 'linux'/process.platform === 'linux' || process.platform === 'android'/" \
		app/node_modules/native-process-working-directory/index.js
	grep -q "process.platform === 'android'" app/node_modules/native-process-working-directory/index.js ||
		termux_error_exit "Failed to patch native-process-working-directory"
	# - node-pty and the other platform's binaries are not usable
	rm -rf app/node_modules/node-pty/prebuilds
	find app/node_modules/@serialport/bindings-cpp/prebuilds -mindepth 1 -maxdepth 1 \
		! -name 'android-*' -exec rm -rf {} + 2>/dev/null || true
	rm -f app/node_modules/russh/russh.*.node

	# Build the SSH engine from source
	(
		cd russh-napi-src
		local _cargo_env="${CARGO_TARGET_NAME//-/_}"
		export "CC_${_cargo_env}=$CC"
		export "AR_${_cargo_env}=$AR"
		cargo build --release --locked \
			--target "$CARGO_TARGET_NAME" \
			--jobs "$TERMUX_PKG_MAKE_PROCESSES"
	)
	install -Dm755 \
		"russh-napi-src/target/$CARGO_TARGET_NAME/release/librussh_napi.so" \
		"app/node_modules/russh/russh.android-$NPM_CONFIG_ARCH.node"
	cat > app/node_modules/russh/lib/native.js <<-'EOF'
	module.exports = require(`../russh.android-${process.arch}.node`)
	EOF

	yarn build
	TABBY_SKIP_NATIVE_REBUILD=1 node scripts/prepackage-plugins.mjs

	# Only app.asar is needed from electron-builder, so give it a
	# placeholder "electron" binary
	local _electron_dist_dir="$TERMUX_PKG_TMPDIR/electron-dist"
	rm -rf "$_electron_dist_dir"
	mkdir -p "$_electron_dist_dir"
	touch "$_electron_dist_dir/electron"
	chmod 0755 "$_electron_dist_dir/electron"

	local _electron_version
	_electron_version="$(. "$TERMUX_SCRIPTDIR/x11-packages/electron42-host-tools/build.sh"; echo "$TERMUX_PKG_VERSION")"

	yarn electron-builder \
		--linux --"$_electron_arch" --dir \
		--publish never \
		-c.electronDist="$_electron_dist_dir" \
		-c.electronVersion="$_electron_version" \
		-c.extraMetadata.version="$TERMUX_PKG_VERSION" \
		-c.npmRebuild=false
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find dist -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under dist"
	fi

	local dest="$TERMUX_PREFIX/opt/tabby"
	rm -rf "$dest"
	mkdir -p "$dest"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# Install the launcher shim. See: x11-packages/tabby/tabby-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/tabby-shim.sh" \
		> "$TERMUX_PREFIX/bin/tabby"
	chmod 0755 "$TERMUX_PREFIX/bin/tabby"

	install -Dm644 build/icons/512x512.png \
		"$TERMUX_PREFIX/share/icons/hicolor/512x512/apps/tabby.png"

	mkdir -p "$TERMUX_PREFIX/share/applications"
	cat > "$TERMUX_PREFIX/share/applications/tabby.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Tabby
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/tabby %U
	Icon=tabby
	Type=Application
	Categories=System;TerminalEmulator;Utility;
	StartupWMClass=tabby
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/tabby"
	fi
	EOF
}
