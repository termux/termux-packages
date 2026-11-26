TERMUX_PKG_HOMEPAGE=https://gdevelop.io
TERMUX_PKG_DESCRIPTION="Open-source, cross-platform game engine designed for everyone"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="5.6.284"

# Prebuilt libGD.js (Core compiled to wasm) published by upstream CI for the release commit.
# Rewritten by termux_pkg_auto_update() below, which fails if the new release has none yet.
_LIBGD_COMMIT="3fb59a81a4e6320bc50828e23a16dcd3d8485f59"

TERMUX_PKG_SRCURL=(
	"https://github.com/4ian/GDevelop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	"https://s3.amazonaws.com/gdevelop-gdevelop.js/master/commit/${_LIBGD_COMMIT}/libGD.js"
	"https://s3.amazonaws.com/gdevelop-gdevelop.js/master/commit/${_LIBGD_COMMIT}/libGD.wasm"
)
TERMUX_PKG_SHA256=(
	d8223ceab90581adfbf63dcc9df2d0cdfab6d7512a57494499e3983162d1102c
	3782f172a0c6a75a572cf7a3bdf34f90d5df0665eafba35f2509f67057d65179
	e90bad7f8c92c578b926648ec428c6175cd535d562bbb787ba2561ce122152c9
)
TERMUX_PKG_AUTO_UPDATE=true
# Only stable tags (no -beta etc.). The lookahead also stops the match from backtracking into a shorter number.
TERMUX_PKG_UPDATE_VERSION_REGEXP='v\d+\.\d+\.\d+(?![\d-])'

TERMUX_PKG_DEPENDS="electron42, libx11, xdg-utils"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

termux_pkg_auto_update() {
	# termux_github_api_get_tag returns the 20 newest tags when TERMUX_PKG_UPDATE_VERSION_REGEXP is set,
	# so pick the newest one matching the regexp the same way termux_pkg_upgrade_version does.
	local latest_tag
	latest_tag="$(termux_github_api_get_tag | sort -rV |
		grep --max-count=1 --only-matching --perl-regexp "${TERMUX_PKG_UPDATE_VERSION_REGEXP}" || :)"
	[[ -n "${latest_tag}" ]] || termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL[0]}"

	# Only rewrite the pin when an update will really happen.
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${latest_tag#v}" &&
		[[ "${BUILD_PACKAGES}" != "false" && -z "${TERMUX_PKG_UPGRADE_VERSION_DRY_RUN:-}" ]]; then
		# Annotated tags list the commit on a peeled "^{}" line, which sorts last.
		local commit
		commit="$(git ls-remote --tags https://github.com/4ian/GDevelop.git \
			"refs/tags/${latest_tag}" "refs/tags/${latest_tag}^{}" | tail -n 1 | cut -f1)"
		[[ -n "${commit}" ]] || termux_error_exit "Tag ${latest_tag} not found in GDevelop"
		# --head only requests the response headers, so the file is checked without being downloaded.
		curl --fail --silent --location --head "https://s3.amazonaws.com/gdevelop-gdevelop.js/master/commit/${commit}/libGD.wasm" > /dev/null ||
			termux_error_exit "libGD.wasm for GDevelop ${latest_tag} (${commit}) is not published yet"
		sed -e "s/^\(_LIBGD_COMMIT=\).*/\1\"${commit}\"/" -i "${TERMUX_PKG_BUILDER_DIR}/build.sh"
	fi

	# Leading non-digits are stripped by termux_pkg_upgrade_version.
	termux_pkg_upgrade_version "${latest_tag}"
}

# libGD.js and libGD.wasm are plain files, not archives.
termux_extract_src_archive() {
	local cache="$TERMUX_PKG_CACHEDIR"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$cache/$(basename "${TERMUX_PKG_SRCURL[0]}")" -C "$TERMUX_PKG_SRCDIR" --strip-components=1
	cp "$cache/libGD.js" "$cache/libGD.wasm" "$TERMUX_PKG_SRCDIR/newIDE/app/public/"
}

termux_step_make() {
	termux_setup_electron "$TERMUX_PKG_SRCDIR/newIDE/electron-app/package.json"

	# Same heap size as upstream CI
	export NODE_OPTIONS="--max-old-space-size=7168"
	export CI=false

	local _ide="$TERMUX_PKG_SRCDIR/newIDE"

	# Lifecycle scripts are skipped: upstream postinstall fetches libGD.js using git metadata, which a tarball lacks
	(cd "$TERMUX_PKG_SRCDIR/GDJS" && npm ci --ignore-scripts && npx patch-package)
	(cd "$_ide/app" && npm ci --ignore-scripts && npx patch-package)
	(cd "$_ide/electron-app" && npm ci --ignore-scripts)
	(cd "$_ide/electron-app/app" && npm ci --ignore-scripts)

	# Same order as upstream "import-resources", minus import-libGD.js
	(
		cd "$_ide/app"
		npm run make-version-metadata
		npm run import-zipped-external-editors
		npm run build-theme-resources
		npm run make-service-worker
		cd scripts
		node import-GDJS-Runtime.js
		node import-monaco-editor.js
		node import-zipped-external-libs.js
	)

	# import-GDJS-Runtime.js exits 0 even when the runtime build fails
	if [[ ! -f "$_ide/app/resources/GDJS/Runtime/gd.js" ]]; then
		termux_error_exit "GDJS runtime was not built"
	fi

	(
		cd "$_ide/app"
		npx react-app-rewired build
		node scripts/check-build-output.js
	)

	# Same as electron-app "app-build" script, without its npm run build
	(
		cd "$_ide/electron-app"
		node scripts/copy-electron-remote-to-app-resources.js
		rm -rf app/www
		mkdir -p app/www
		cp -r ../app/build/* app/www/

		# Only app.asar and extra resources are needed from electron-builder
		npm exec electron-builder -- \
			--linux --"$TERMUX_ELECTRON_ARCH" --dir --publish=never \
			--config electron-builder-config.js \
			-c.electronDist="$TERMUX_ELECTRON_DIST" \
			-c.electronVersion="$TERMUX_ELECTRON_VERSION" \
			-c.npmRebuild=false
	)
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find newIDE/electron-app/dist -maxdepth 1 -type d -name "linux-*unpacked")
	if [[ ! -e "${_dist_dir:-not_found}/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under newIDE/electron-app/dist"
	fi

	local dest="$TERMUX_PREFIX/opt/gdevelop"
	rm -rf "$dest"
	mkdir -p "$dest"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# `xdg-open` from termux-tools opens things on Android, not in X11.
	# Electron and five-server call it by name, so shadow it on the launcher's PATH.
	mkdir -p "$dest/bin"
	ln -sf "$TERMUX_PREFIX/bin/xdg-utils-xdg-open" "$dest/bin/xdg-open"

	# Install the launcher shim. See: x11-packages/gdevelop/gdevelop-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/gdevelop-shim.sh" \
		> "$TERMUX_PREFIX/bin/gdevelop"
	chmod 0755 "$TERMUX_PREFIX/bin/gdevelop"

	install -Dm600 newIDE/app/public/android-chrome-512x512.png \
		"$TERMUX_PREFIX/share/icons/hicolor/512x512/apps/gdevelop.png"

	mkdir -p "$TERMUX_PREFIX/share/applications"
	cat > "$TERMUX_PREFIX/share/applications/gdevelop.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=GDevelop
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/gdevelop %f
	Icon=gdevelop
	Type=Application
	Categories=Development;IDE;Game;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/gdevelop"
	fi
	EOF
}
