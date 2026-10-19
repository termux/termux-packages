TERMUX_PKG_HOMEPAGE=https://playwright.dev
TERMUX_PKG_DESCRIPTION="Browser automation library and test runner for JavaScript/TypeScript"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, NOTICE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.64.1"
TERMUX_PKG_SRCURL="https://github.com/microsoft/playwright/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4cf21457cd00395c83b29e7f787b72e8b3bb00cee14728c69ac80a12ae42f089
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_DEPENDS="chromium, nodejs | nodejs-lts"
TERMUX_PKG_RECOMMENDS="ffmpeg, firefox"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_nodejs

	# Skip lifecycle scripts and browser downloads, the system chromium is used
	PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 npm ci --ignore-scripts
	npm run build
}

termux_step_make_install() {
	local _mods="$TERMUX_PREFIX/lib/node_modules"
	local _pkg
	rm -rf "$_mods/playwright" "$_mods/playwright-core" "$_mods/@playwright/test"

	for _pkg in playwright-core playwright playwright-test; do
		local _name
		_name=$(node -p "require('./packages/$_pkg/package.json').name")
		mkdir -p "$_mods/$_name"
		# Only the built output and manifests are needed at runtime
		(cd "packages/$_pkg" && find . -mindepth 1 -maxdepth 1 ! -name src ! -name node_modules -exec cp -a {} "$_mods/$_name/" \;)
	done

	local _bin
	for _bin in playwright:playwright playwright-core:playwright-core; do
		# Never download browsers, the system chromium is used
		cat > "$TERMUX_PREFIX/bin/${_bin%%:*}" <<-SH
		#!$TERMUX_PREFIX/bin/sh
		PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 exec node "$_mods/${_bin##*:}/cli.js" "\$@"
		SH
		chmod 0755 "$TERMUX_PREFIX/bin/${_bin%%:*}"
	done
}

termux_step_create_debscripts() {
	# Global modules are not on Node's search path by default
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "To use require('playwright'), run: export NODE_PATH=$TERMUX_PREFIX/lib/node_modules"
	echo "For ESM/TypeScript projects, run: npm link playwright"
	EOF
}
