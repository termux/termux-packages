TERMUX_PKG_HOMEPAGE=https://vencord.dev
TERMUX_PKG_DESCRIPTION="Vesktop is a custom Discord desktop app"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	"1.6.8"
	"7.2.3"
)
TERMUX_PKG_SRCURL=(
	"https://github.com/Vencord/Vesktop/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/Vencord/venmic/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	"91dd4630fb5fff153586056451a9587f4c5fbeb048c6d570a35056460415f22f"
	"5bed271f1777e5e794273899a590e7f511e6131a8122e3c83f85bc3bf22cfc50"
)
TERMUX_PKG_DEPENDS="electron43, glib, libx11, pipewire, pulseaudio, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="electron43-headers, pkg-config"
TERMUX_ELECTRON_MAJOR=43
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	mv "${TERMUX_PKG_SRCDIR}/venmic-${TERMUX_PKG_VERSION[1]}" "${TERMUX_PKG_SRCDIR}/venmic"
}

termux_step_make() {
	termux_setup_electron "$TERMUX_PKG_SRCDIR/package.json"
	termux_setup_cmake
	termux_setup_ninja

	local tool_dir="$TERMUX_PKG_TMPDIR/tools"
	mkdir -p "$tool_dir"
	npm install --prefix "$tool_dir" pnpm@11.9.0 @electron/asar node-gyp
	export PATH="$tool_dir/node_modules/.bin:$PATH"

	pnpm install --frozen-lockfile --ignore-scripts

	local node_addon_api
	node_addon_api="$(find "$TERMUX_PKG_SRCDIR/node_modules" -type d -name "node-addon-api" | head -n 1)"
	if [[ ! -d "$node_addon_api" ]]; then
		termux_error_exit "Could not find node-addon-api directory in dependencies"
	fi

	(
		cd packages/libvesktop
		export NODE_PATH="$TERMUX_PKG_SRCDIR/node_modules"
		export PKG_CONFIG_LIBDIR="${TERMUX_PREFIX}/lib/pkgconfig:${TERMUX_PREFIX}/share/pkgconfig"
		export LDFLAGS="${LDFLAGS} -L${TERMUX_PREFIX}/lib"

		node-gyp rebuild \
			--arch="${NPM_CONFIG_ARCH}" \
			--nodedir="${npm_config_nodedir}"
	)

	(
		local venmic_build="$TERMUX_PKG_TMPDIR/venmic-build"
		rm -rf "$venmic_build"
		mkdir -p "$venmic_build"
		cd "$venmic_build"

		TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/venmic"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
			-Dvenmic_addon=ON
			-Dvenmic_server=OFF
			-Dvenmic_use_fill=ON
			-DCMAKE_JS_VERSION=7.3.0
			-DCMAKE_JS_INC=${npm_config_nodedir}/include/node;${node_addon_api}
			-DCMAKE_JS_LIB=
		"

		termux_step_configure_cmake
		ninja -j "${TERMUX_PKG_MAKE_PROCESSES}"
	)

	pnpm build

	local app_dir="$TERMUX_PKG_TMPDIR/app"
	rm -rf "$app_dir"
	mkdir -p "$app_dir/static/dist"

	cp -r dist "$app_dir/dist"
	cp -r static/* "$app_dir/static/"
	rm -rf "$app_dir/static/dist"
	mkdir -p "$app_dir/static/dist"
	cp LICENSE "$app_dir/LICENSE"

	jq '{name, version, main, description, license}' package.json >"$app_dir/package.json"

	local libvesktop venmic
	libvesktop="$(find packages/libvesktop/build/Release -name "*.node" | head -n 1)"
	venmic="$(find "$TERMUX_PKG_TMPDIR/venmic-build" -name "*.node" | head -n 1)"

	[[ -f "$libvesktop" ]] || termux_error_exit "Failed to find built libvesktop.node"
	[[ -f "$venmic" ]] || termux_error_exit "Failed to find built venmic-addon.node"

	cp "$libvesktop" "$app_dir/static/dist/libvesktop-${NPM_CONFIG_ARCH}.node"
	cp "$venmic" "$app_dir/static/dist/venmic-${NPM_CONFIG_ARCH}.node"

	local pack_dir
	pack_dir="$(mktemp -d /tmp/vesktop.XXXXXX)"
	mv "$app_dir" "$pack_dir/app"
	asar pack "$pack_dir/app" "$pack_dir/app.asar" --unpack "**/*.node"
	mv "$pack_dir"/app.asar* "$TERMUX_PKG_TMPDIR/"
	rm -rf "$pack_dir"
}

termux_step_make_install() {
	if [[ ! -e "$TERMUX_PKG_TMPDIR/app.asar" ]]; then
		termux_error_exit "app.asar not found in $TERMUX_PKG_TMPDIR"
	fi

	local dest="$TERMUX_PREFIX/opt/vesktop"
	rm -rf "$dest"
	mkdir -p "$dest/resources"
	cp -r "$TERMUX_PKG_TMPDIR"/app.asar* "$dest/resources/"

	mkdir -p "$dest/bin"
	ln -sf "$TERMUX_PREFIX/bin/xdg-utils-xdg-open" "$dest/bin/xdg-open"

	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/vesktop-shim.sh" \
		>"$TERMUX_PREFIX/bin/vesktop"
	chmod 0755 "$TERMUX_PREFIX/bin/vesktop"

	install -Dm644 build/icon.svg \
		"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/vesktop.svg"

	cat >"$TERMUX_PREFIX/share/applications/vesktop.desktop" <<-DESKTOP
		[Desktop Entry]
		Name=Vesktop
		GenericName=Internet Messenger
		Comment=$TERMUX_PKG_DESCRIPTION
		Exec=$TERMUX_PREFIX/bin/vesktop %U
		Icon=vesktop
		Type=Application
		Terminal=false
		Categories=Network;InstantMessaging;Chat;
		Keywords=discord;vencord;electron;chat;
		MimeType=x-scheme-handler/discord;
		StartupWMClass=vesktop
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<-EOF >postrm
		#!$TERMUX_PREFIX/bin/sh
		if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
			rm -rf "$TERMUX_PREFIX/opt/vesktop"
		fi
	EOF
}
