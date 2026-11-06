TERMUX_PKG_HOMEPAGE="https://www.cross-seed.org/"
TERMUX_PKG_DESCRIPTION="Fully-automatic cross-seeding with Torznab"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.13.9"
TERMUX_PKG_SRCURL="https://github.com/cross-seed/cross-seed/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5fe850509079ee455629d13d30916036ff11c48f086704bd3c28006cb3caeccb
TERMUX_PKG_BUILD_DEPENDS="nodejs, python"
# better-sqlite3 is a native C++ addon built against target nodejs ABI.
# Do NOT use "nodejs | nodejs-lts" until cross-seed 7.x (which drops better-sqlite3 for built-in node:sqlite).
# Revbump when nodejs moves to a new major.
TERMUX_PKG_DEPENDS="nodejs, termux-services"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"cross-seed"
	"exec ${TERMUX_PREFIX}/bin/cross-seed daemon 2>&1"
)

termux_step_pre_configure() {
	termux_setup_nodejs

	# Setup cross-compilation environment for node-gyp (better-sqlite3)
	export CC=$CC
	export CXX=$CXX
	export AR=$AR
	export LINK=$CXX

	local GYP_ARCH
	case "$TERMUX_ARCH" in
	aarch64) GYP_ARCH="arm64" ;;
	arm) GYP_ARCH="arm" ;;
	i686) GYP_ARCH="ia32" ;;
	x86_64) GYP_ARCH="x64" ;;
	esac
	export npm_config_arch=$GYP_ARCH
	export npm_config_platform=android
	export npm_config_nodedir="${TERMUX_PREFIX}"

	npm ci --ignore-scripts
}

termux_step_make() {
	npm run build
}

termux_step_make_install() {
	npm prune --omit=dev --ignore-scripts

	# Setup cross-compilation environment variables
	local GYP_ARCH
	case "$TERMUX_ARCH" in
	aarch64) GYP_ARCH="arm64" ;;
	arm) GYP_ARCH="arm" ;;
	i686) GYP_ARCH="ia32" ;;
	x86_64) GYP_ARCH="x64" ;;
	esac

	# Compile better-sqlite3 against target Node.js headers
	CC=$CC CXX=$CXX AR=$AR LINK=$CXX \
		npm_config_arch=$GYP_ARCH \
		npm_config_platform=android \
		npm_config_build_from_source=true \
		npm_config_nodedir="${TERMUX_PREFIX}" \
		npm rebuild better-sqlite3

	local _dir="${TERMUX_PREFIX}/lib/cross-seed"
	rm -rf "$_dir"
	mkdir -p "$_dir"

	cp -r dist node_modules package.json "$_dir/"

	# Remove incompatible host prebuilds if any
	rm -rf "$_dir/node_modules/better-sqlite3/prebuilds"

	# Strip native Node.js binaries
	find "$_dir/node_modules" -name "*.node" -exec sh -c '${STRIP} --strip-unneeded "$1" 2>/dev/null || true' _ {} \;

	# Remove native build intermediate objects and static archives to save space
	find "$_dir/node_modules" -type d -name "obj.target" -exec rm -rf {} +
	find "$_dir/node_modules" -type f \( -name "*.a" -o -name "*.la" \) -delete

	# Remove useless dev/doc files from node_modules while preserving license notices
	find "$_dir/node_modules" -type f \( \
		-name "*.md" -o \
		-name "*.map" -o \
		-name "*.ts" -o \
		-name "*.tsx" -o \
		-name "Makefile" \
		\) -delete

	find "$_dir/node_modules" -type d \( \
		-name "test" -o \
		-name "tests" -o \
		-name "__tests__" -o \
		-name "docs" -o \
		-name "doc" -o \
		-name "example" -o \
		-name "examples" -o \
		-name ".github" -o \
		-name ".circleci" -o \
		-name ".husky" \
		\) -exec rm -rf {} +

	# Create launcher
	cat >"${TERMUX_PREFIX}/bin/cross-seed" <<-HERE
		#!${TERMUX_PREFIX}/bin/sh
		exec node "${_dir}/dist/cmd.js" "\$@"
	HERE
	chmod 0755 "${TERMUX_PREFIX}/bin/cross-seed"
}
