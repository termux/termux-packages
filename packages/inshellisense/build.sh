TERMUX_PKG_HOMEPAGE=https://github.com/microsoft/inshellisense
TERMUX_PKG_DESCRIPTION="IDE style command line auto complete"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.0.4"
TERMUX_PKG_SRCURL="https://github.com/microsoft/inshellisense/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a621921f9fbd8ebabe986399cd82ba5b595bf8d99949869aa608e847bdd943cc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_nodejs

	# The version is normally substituted into the single-file release bundle
	sed -i "s|__VERSION__|${TERMUX_PKG_VERSION}|" src/utils/version.ts

	# Outside a release bundle, shell scripts and specs are read from the
	# current directory (only correct when run from a source checkout)
	sed -i "s|process.cwd()|\"${TERMUX_PREFIX}/lib/inshellisense\"|g" src/utils/node.ts

	if ! grep -q "\"${TERMUX_PKG_VERSION}\"" src/utils/version.ts ||
		! grep -q "lib/inshellisense" src/utils/node.ts; then
		termux_error_exit "Failed to patch version.ts / node.ts"
	fi
}

termux_step_make() {
	termux_setup_nodejs

	npm ci --ignore-scripts
	npm run build
	npm prune --omit=dev --ignore-scripts

	# Not used at runtime (65 MiB)
	rm -rf node_modules/@fig

	local GYP_ARCH
	case "$TERMUX_ARCH" in
	aarch64) GYP_ARCH="arm64" ;;
	arm) GYP_ARCH="arm" ;;
	i686) GYP_ARCH="ia32" ;;
	x86_64) GYP_ARCH="x64" ;;
	esac

	# build_from_source: node-pty would otherwise use its bundled linux-x64
	# prebuild, which matches the build host instead of the target
	CC=$CC CXX=$CXX AR=$AR LINK=$CXX \
		npm_config_arch=$GYP_ARCH \
		npm_config_platform=android \
		npm_config_build_from_source=true \
		npm rebuild node-pty
}

termux_step_make_install() {
	local _dir="$TERMUX_PREFIX/lib/inshellisense"

	rm -rf "$_dir"
	install -d "$_dir"
	cp -r build node_modules shell package.json "$_dir/"
	rm -rf "$_dir/build/tests"

	cat > "$TERMUX_PREFIX/bin/inshellisense" <<-EOF
	#!${TERMUX_PREFIX}/bin/sh
	exec node "${_dir}/build/index.js" "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/inshellisense"
	ln -sf inshellisense "$TERMUX_PREFIX/bin/is"
}
