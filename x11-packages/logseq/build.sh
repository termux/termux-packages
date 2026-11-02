TERMUX_PKG_HOMEPAGE=https://logseq.com
TERMUX_PKG_DESCRIPTION="Privacy-first platform for knowledge management and collaboration"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.0.2"
_CLOJURE_VERSION="1.12.6.1673"
TERMUX_PKG_SRCURL=(
	"https://github.com/logseq/logseq/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/clojure/brew-install/releases/download/${_CLOJURE_VERSION}/clojure-tools-${_CLOJURE_VERSION}.tar.gz"
)
TERMUX_PKG_SHA256=(
	2c3b46a9277400dd4353e30ccbf10b301624c14b37e764e14713b2f89d8f2241
	fe9194858e75d5af13c2e2aff92d710674d5bc5105f2b42f90a7d94d82ec023c
)
TERMUX_PKG_DEPENDS="electron42, libx11"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

_LOGSEQ_REQUIRED_MODULES="electron-log electron-updater electron-window-state fastify"

_logseq_asar_has_deps() {
	local _asar_list="$TERMUX_PKG_TMPDIR/asar-list.txt" _mod _ok=true
	"$TERMUX_PKG_TMPDIR/asar/node_modules/.bin/asar" list "$1" > "$_asar_list"
	echo "app.asar: $(grep -c '^/node_modules/' "$_asar_list" || true) entries under node_modules"
	for _mod in $_LOGSEQ_REQUIRED_MODULES; do
		if ! grep -qx "/node_modules/$_mod/package.json" "$_asar_list"; then
			echo "app.asar: $_mod is missing"
			_ok=false
		fi
	done
	$_ok
}

# Replace node_modules inside app.asar with a flat production-only install
_logseq_repack_asar() {
	local _asar_bin="$TERMUX_PKG_TMPDIR/asar/node_modules/.bin/asar"
	local _work="$TERMUX_PKG_TMPDIR/asar-repack"
	rm -rf "$_work"
	"$_asar_bin" extract "$1" "$_work"
	rm -rf "$_work/node_modules" "$_work/pnpm-lock.yaml"

	# The file: dependency is relative to the source tree; make it absolute
	jq --arg dep "file:$TERMUX_PKG_SRCDIR/deps/graph-lifecycle" \
		'.dependencies["@logseq/graph-lifecycle"] = $dep' \
		"$_work/package.json" > "$_work/package.json.new"
	mv "$_work/package.json.new" "$_work/package.json"

	(
		cd "$_work"
		pnpm install --ignore-workspace --prod --no-frozen-lockfile \
			--ignore-scripts --config.node-linker=hoisted
	)
	rm -f "$1"
	rm -rf "$1.unpacked"
	"$_asar_bin" pack "$_work" "$1"
}

termux_step_post_get_source() {
	local _clj_dir="$TERMUX_PKG_SRCDIR/clojure-tools"
	mkdir -p "$_clj_dir/bin" "$_clj_dir/libexec"
	mv "$_clj_dir"/*.jar "$_clj_dir/libexec/"
	sed "s|PREFIX|${_clj_dir}|g" "$_clj_dir/clojure" > "$_clj_dir/bin/clojure"
	chmod 0755 "$_clj_dir/bin/clojure"
}

termux_step_pre_configure() {
	termux_setup_electron

	# Upstream pins pnpm 10 via packageManager
	npm install --prefix "$TERMUX_PKG_TMPDIR/pnpm" pnpm@10.33.0
	# Used to inspect app.asar after electron-builder
	npm install --prefix "$TERMUX_PKG_TMPDIR/asar" @electron/asar@3.4.1
	export PATH="$TERMUX_PKG_SRCDIR/clojure-tools/bin:$TERMUX_PKG_TMPDIR/pnpm/node_modules/.bin:$PATH"
}

termux_step_make() {
	export CI=true

	# --ignore-scripts: keytar/zvec/better-sqlite3 have no android build
	pnpm install --frozen-lockfile --ignore-scripts

	pnpm gulp:build

	# Same targets as upstream cljs:release-electron
	clojure -M:cljs release app db-worker db-worker-node electron publishing
	pnpm db-worker-node:bundle
	pnpm webpack-app-build
	pnpm desktop:prepare-runtime-js

	cd static
	rm -rf mobile android ios

	local _pkg_json
	_pkg_json=$(jq 'del(.dependencies.keytar, .optionalDependencies)' package.json)
	echo "$_pkg_json" > package.json
	pnpm install --ignore-workspace --no-frozen-lockfile --ignore-scripts

	# Only app.asar is needed from electron-builder; termux_setup_electron
	# already provides a placeholder "electron" binary in $TERMUX_ELECTRON_DIST
	pnpm exec electron-builder \
		--config electron-builder.yml --publish never \
		--linux --"$TERMUX_ELECTRON_ARCH" --dir \
		-c.electronDist="$TERMUX_ELECTRON_DIST" \
		-c.electronVersion="$TERMUX_ELECTRON_VERSION" \
		-c.npmRebuild=false

	# electron-builder sometimes produces an app.asar without the runtime
	# dependencies, which only shows up at launch as
	# "Cannot find module 'electron-log'". Verify, and repack if needed.
	local _asar_file
	_asar_file=$(find dist -maxdepth 3 -name app.asar | head -n 1)
	if ! _logseq_asar_has_deps "$_asar_file"; then
		echo "WARNING: runtime dependencies missing from app.asar, repacking"
		_logseq_repack_asar "$_asar_file"
		_logseq_asar_has_deps "$_asar_file" ||
			termux_error_exit "runtime dependencies are still missing from app.asar"
	fi
}

termux_step_make_install() {
	local _dist_dir
	_dist_dir=$(find static/dist -maxdepth 1 -type d -name "*-unpacked")
	if [[ -z "$_dist_dir" || ! -e "$_dist_dir/resources/app.asar" ]]; then
		termux_error_exit "electron-builder output not found under static/dist"
	fi

	local dest="$TERMUX_PREFIX/opt/logseq"
	rm -rf "$dest"
	mkdir -p "$dest"
	cp -r "$_dist_dir/resources" "$dest/resources"

	# Install the launcher shim. See: x11-packages/logseq/logseq-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/logseq-shim.sh" \
		> "$TERMUX_PREFIX/bin/logseq"
	chmod 0755 "$TERMUX_PREFIX/bin/logseq"

	install -Dm644 resources/icons/logseq.png \
		"$TERMUX_PREFIX/share/icons/hicolor/512x512/apps/logseq.png"

	mkdir -p "$TERMUX_PREFIX/share/applications"
	cat > "$TERMUX_PREFIX/share/applications/logseq.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Logseq
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/logseq %U
	Icon=logseq
	Type=Application
	Categories=Office;
	StartupWMClass=Logseq
	MimeType=x-scheme-handler/logseq;
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/logseq"
	fi
	EOF
}
