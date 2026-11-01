TERMUX_PKG_HOMEPAGE=https://www.drawio.com
TERMUX_PKG_DESCRIPTION="Diagram editor for flowcharts, UML, network diagrams and more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="32.4.1"
# The release tarballs do not contain the "drawio" submodule (web editor), so a git checkout is required.
TERMUX_PKG_SRCURL="git+https://github.com/jgraph/drawio-desktop"
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="electron42, fontconfig, libx11, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_make() {
	termux_setup_electron "$TERMUX_PKG_SRCDIR/package.json"

	npm ci

	# Only app.asar is needed from electron-builder; termux_setup_electron
	# already provides a placeholder "electron" binary in $TERMUX_ELECTRON_DIST
	npm exec electron-builder -- \
		--linux --"$TERMUX_ELECTRON_ARCH" --dir --publish never \
		--config electron-builder-linux-mac.json \
		-c.electronDist="$TERMUX_ELECTRON_DIST" \
		-c.electronVersion="$TERMUX_ELECTRON_VERSION" \
		-c.npmRebuild=false
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find dist -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under dist"
	fi

	local dest="$TERMUX_PREFIX/opt/drawio"
	rm -rf "$dest"
	mkdir -p "$dest/bin"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# Electron's shell.openExternal/openPath spawn "xdg-open" from PATH
	ln -sf "$TERMUX_PREFIX/bin/xdg-utils-xdg-open" "$dest/bin/xdg-open"

	# Install the launcher shim. See: x11-packages/drawio/drawio-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/drawio-shim.sh" \
		> "$TERMUX_PREFIX/bin/drawio"
	chmod 0755 "$TERMUX_PREFIX/bin/drawio"

	local _size
	for _size in 16 32 48 64 128 256 512; do
		install -Dm644 "build/${_size}x${_size}.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${_size}x${_size}/apps/drawio.png"
	done

	cat > "$TERMUX_PREFIX/share/applications/drawio.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=draw.io
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/drawio %U
	Icon=drawio
	Type=Application
	Categories=Graphics;
	StartupWMClass=draw-io
	MimeType=application/vnd.jgraph.mxfile;application/vnd.visio;text/vnd.mermaid;
	DESKTOP

	# shared-mime-info has no entry for .drawio and .mmd
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/drawio.xml" \
		"$TERMUX_PREFIX/share/mime/packages/drawio.xml"
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/drawio"
	fi
	EOF
}
