TERMUX_PKG_HOMEPAGE=https://hyper.is
TERMUX_PKG_DESCRIPTION="A terminal built on web technologies"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.4.1"
TERMUX_PKG_SRCURL="https://github.com/vercel/hyper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6d691955f16496d0ffb3c5885d8e00dbc387919216629a65ec326dacb2358e75
TERMUX_PKG_DEPENDS="electron42, libx11, xdg-utils"
TERMUX_PKG_BUILD_DEPENDS="electron42-headers, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=true
# Chromium/Electron don't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_electron "$TERMUX_PKG_SRCDIR/package.json"

	# Upstream postinstall builds x64-only snapshots and runs electron-rebuild; do the needed steps by hand.
	local _yarn="node $TERMUX_PKG_SRCDIR/bin/yarn-standalone.js"
	local _flags="--ignore-scripts --ignore-engines --ignore-platform --non-interactive"

	$_yarn install $_flags --frozen-lockfile
	(cd app && $_yarn install $_flags --frozen-lockfile)

	# node-pty has no android prebuild; npm builds it from source against the electron headers.
	(cd app && npm rebuild node-pty)
	if [[ ! -f app/node_modules/node-pty/build/Release/pty.node ]]; then
		termux_error_exit "node-pty build failed"
	fi

	npx cross-env NODE_ENV=production webpack
	npx tsc -b

	# The renderer requires these from ./node_modules at runtime, but only the root package.json lists them.
	local _externals
	_externals=$(grep -oh 'require("\./node_modules/[^/"]*' target/renderer/bundle.js | sed 's|.*node_modules/||' | sort -u)
	local _rdeps="$TERMUX_PKG_TMPDIR/renderer-deps"
	rm -rf "$_rdeps"
	mkdir -p "$_rdeps"
	cp package.json yarn.lock .yarnrc "$_rdeps/"
	node -e '
		const fs = require("fs");
		const file = process.argv[1] + "/package.json";
		const pkg = require(file);
		const all = Object.assign({}, pkg.devDependencies, pkg.dependencies);
		const dependencies = {};
		for (const name of process.argv.slice(2)) if (all[name]) dependencies[name] = all[name];
		fs.writeFileSync(file, JSON.stringify({name: "renderer-deps", version: "0.0.0", private: true, dependencies}));
	' "$_rdeps" $_externals
	(cd "$_rdeps" && $_yarn install $_flags --production)

	rm -rf target/node_modules target/ignore_this.js
	cp -r app/node_modules target/node_modules
	node -e '
		const fs = require("fs");
		const path = require("path");
		const [from, to] = process.argv.slice(1);
		const add = (rel) => {
			if (!fs.existsSync(path.join(to, rel))) fs.cpSync(path.join(from, rel), path.join(to, rel), {recursive: true});
		};
		for (const name of fs.readdirSync(from)) {
			if (name.startsWith(".")) continue;
			if (!name.startsWith("@")) add(name);
			else for (const sub of fs.readdirSync(path.join(from, name))) add(path.join(name, sub));
		}
	' "$_rdeps/node_modules" target/node_modules

	# Keep only what node-pty needs at runtime.
	local _pty=target/node_modules/node-pty
	rm -rf "$_pty"/{src,deps,third_party,scripts,prebuilds,node_modules,typings}
	find "$_pty/build" -mindepth 1 -maxdepth 1 ! -name Release -exec rm -rf {} +
	find "$_pty/build/Release" -mindepth 1 -maxdepth 1 ! -name pty.node -exec rm -rf {} +
}

termux_step_make_install() {
	local _dest="$TERMUX_PREFIX/opt/hyper"
	rm -rf "$_dest"
	mkdir -p "$_dest/bin"
	cp -r target "$_dest/app"

	# The app resolves these as ../../bin relative to its config dir.
	install -Dm644 bin/cli.js bin/yarn-standalone.js -t "$_dest/bin"
	ln -s "$TERMUX_PREFIX/bin/xdg-utils-xdg-open" "$_dest/bin/xdg-open"

	# Install the launcher shim. See: x11-packages/hyper/hyper-shim.sh
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR/hyper-shim.sh" \
		> "$TERMUX_PREFIX/bin/hyper"
	chmod 0755 "$TERMUX_PREFIX/bin/hyper"

	install -Dm600 app/static/icon96x96.png \
		"$TERMUX_PREFIX/share/icons/hicolor/96x96/apps/hyper.png"

	cat > "$TERMUX_PREFIX/share/applications/hyper.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Hyper
	Comment=$TERMUX_PKG_DESCRIPTION
	Exec=$TERMUX_PREFIX/bin/hyper
	Icon=hyper
	Type=Application
	Categories=System;TerminalEmulator;
	StartupWMClass=Hyper
	DESKTOP
}

termux_step_create_debscripts() {
	cat <<- EOF > postrm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
		rm -rf "$TERMUX_PREFIX/opt/hyper"
	fi
	EOF
}
