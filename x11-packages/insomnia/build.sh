TERMUX_PKG_HOMEPAGE=https://insomnia.rest
TERMUX_PKG_DESCRIPTION="Open-source API client for GraphQL, REST, WebSockets, SSE and gRPC"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="13.3.1"
TERMUX_PKG_SRCURL="https://github.com/Kong/insomnia/archive/refs/tags/core@${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=12f33e5bcc987144e24e0888c41daf78b5c199be1260915208b76e6983371f7f
TERMUX_PKG_DEPENDS="electron42, libcurl, libx11, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_electron "$TERMUX_PKG_SRCDIR/packages/insomnia/package.json"

	# Same heap size as upstream's release build
	export NODE_OPTIONS="--max_old_space_size=6144"

	# Skip lifecycle scripts: the root postinstall downloads a prebuilt
	# libcurl (no android binary) and node-llama-cpp would compile llama.cpp
	npm ci --ignore-scripts
	npx patch-package

	# git dependency: npm only installs its "files" (no src) and prepare was
	# skipped above, so fetch the locked commit and compile it with tsc
	termux_download \
		"https://codeload.github.com/Kong/grpc-reflection-js/tar.gz/f806b5a0dc2092b7a6fb54dfb66c38fb58231774" \
		"$TERMUX_PKG_TMPDIR/grpc-reflection-js.tar.gz" \
		49271f5e92c3a72ad54b5d4e58e8d8809da684e83e2c6b00650062b699b013d1
	tar -xzf "$TERMUX_PKG_TMPDIR/grpc-reflection-js.tar.gz" \
		-C node_modules/grpc-reflection-js --strip-components=1
	(
		cd node_modules/grpc-reflection-js
		../.bin/tsc --outDir build --rootDir . --module commonjs --target es2018 \
			--moduleResolution node --esModuleInterop --allowJs --declaration \
			--skipLibCheck src/*.ts src/*.js
	)

	# node-libcurl runs curl-config, the target one can't execute on the host
	mkdir -p "$TERMUX_PKG_TMPDIR/bin"
	cat > "$TERMUX_PKG_TMPDIR/bin/curl-config" <<-EOF
	#!/bin/sh
	case "\$1" in
		--prefix) echo "$TERMUX_PREFIX" ;;
		--libs) echo "-L$TERMUX_PREFIX/lib -lcurl" ;;
	esac
	EOF
	chmod 0755 "$TERMUX_PKG_TMPDIR/bin/curl-config"

	# Build node-libcurl from source against the electron headers set above
	(
		cd node_modules/@getinsomnia/node-libcurl
		PATH="$TERMUX_PKG_TMPDIR/bin:$PATH" \
			../../.bin/node-pre-gyp install --build-from-source \
			--target_arch="$NPM_CONFIG_ARCH"
	)

	npm run build --workspace=packages/insomnia

	# Only app.asar is needed from electron-builder; termux_setup_electron
	# already provides a placeholder "electron" binary in $TERMUX_ELECTRON_DIST
	(
		cd packages/insomnia
		npm exec electron-builder -- \
			--linux --"$TERMUX_ELECTRON_ARCH" --dir \
			--config electron-builder.config.js \
			-c.electronDist="$TERMUX_ELECTRON_DIST" \
			-c.electronVersion="$TERMUX_ELECTRON_VERSION" \
			-c.npmRebuild=false
	)
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find packages/insomnia/dist -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under packages/insomnia/dist"
	fi

	local dest="$TERMUX_PREFIX/opt/insomnia"
	rm -rf "$dest"
	mkdir -p "$dest"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# Install the launcher shim. See: x11-packages/insomnia/insomnia-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/insomnia-shim.sh" \
		> "$TERMUX_PREFIX/bin/insomnia"
	chmod 0755 "$TERMUX_PREFIX/bin/insomnia"

	# Upstream ships no png, take the 256x256 one embedded in icon.ico
	mkdir -p "$TERMUX_PREFIX/share/icons/hicolor/256x256/apps"
	tail -c +25231 packages/insomnia/src/icons/icon.ico | head -c 15799 \
		> "$TERMUX_PREFIX/share/icons/hicolor/256x256/apps/insomnia.png"

	cat > "$TERMUX_PREFIX/share/applications/insomnia.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Insomnia
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/insomnia %U
	Icon=insomnia
	Type=Application
	Categories=Development;
	StartupWMClass=Insomnia
	MimeType=x-scheme-handler/insomnia;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/insomnia"
	fi
	EOF
}
