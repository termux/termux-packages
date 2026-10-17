TERMUX_PKG_HOMEPAGE=https://mockoon.com
TERMUX_PKG_DESCRIPTION="Easiest and quickest way to run mock APIs locally"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="9.9.0"
TERMUX_PKG_SRCURL="https://github.com/mockoon/mockoon/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=aa23e0f861b894414219b1d4eec225764a3edd2128bd5cb053613979dcc88c40
TERMUX_PKG_DEPENDS="electron42, libx11, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_electron "$TERMUX_PKG_SRCDIR/packages/app/package.json"

	# Install scripts only fetch e2e test drivers, nothing the build needs
	npm ci --ignore-scripts

	# app depends on the commons, commons-server and cloud workspaces
	npm run build:libs
	npm run build:prod:all --workspace=@mockoon/app

	# Only app.asar is needed from electron-builder; termux_setup_electron
	# already provides a placeholder "electron" binary in $TERMUX_ELECTRON_DIST
	(
		cd packages/app
		npm exec electron-builder -- \
			--linux --"$TERMUX_ELECTRON_ARCH" --dir --publish never \
			--config build-configs/electron-builder.linux.js \
			-c.electronDist="$TERMUX_ELECTRON_DIST" \
			-c.electronVersion="$TERMUX_ELECTRON_VERSION" \
			-c.npmRebuild=false
	)
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find packages/app/packages -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under packages/app/packages"
	fi

	local dest="$TERMUX_PREFIX/opt/mockoon"
	rm -rf "$dest"
	mkdir -p "$dest/bin"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# Electron's shell.openExternal/openPath spawn "xdg-open" from PATH
	ln -sf "$TERMUX_PREFIX/bin/xdg-utils-xdg-open" "$dest/bin/xdg-open"

	# Install the launcher shim. See: x11-packages/mockoon/mockoon-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/mockoon-shim.sh" \
		> "$TERMUX_PREFIX/bin/mockoon"
	chmod 0755 "$TERMUX_PREFIX/bin/mockoon"

	local _size
	for _size in 16 24 32 48 64 96 128 256 512; do
		install -Dm644 "packages/app/build-res/${_size}x${_size}.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${_size}x${_size}/apps/mockoon.png"
	done

	# File name matches desktopName in the packaged package.json
	cat > "$TERMUX_PREFIX/share/applications/com.mockoon.app.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Mockoon
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/mockoon %U
	Icon=mockoon
	Type=Application
	Categories=Development;
	StartupWMClass=mockoon
	MimeType=x-scheme-handler/mockoon;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/mockoon"
	fi
	EOF
}
