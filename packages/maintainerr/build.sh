TERMUX_PKG_HOMEPAGE="https://github.com/maintainerr/Maintainerr"
TERMUX_PKG_DESCRIPTION="An automation rule engine for your media server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.24.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/maintainerr/Maintainerr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=546faf51aa75387895ca3d5210ed667ded6e801bfb94f57b2f382fd09af9d1ec
TERMUX_PKG_BUILD_DEPENDS="nodejs, libvips, libcairo, pango, librsvg, giflib, libpixman, libjpeg-turbo, pkg-config, python"
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts, libvips, libcairo, pango, librsvg, giflib, libpixman, libjpeg-turbo, termux-services"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"maintainerr"
	"exec ${TERMUX_PREFIX}/bin/maintainerr 2>&1"
)

termux_step_pre_configure() {
	termux_setup_nodejs

	# Setup yarn wrapper using bundled Yarn Berry in source repo
	local YARN_BIN="$TERMUX_PKG_TMPDIR/bin"
	mkdir -p "$YARN_BIN"
	cat > "$YARN_BIN/yarn" <<-EOF
		#!/bin/sh
		exec node "$TERMUX_PKG_SRCDIR/.yarn/releases/yarn-4.17.1.cjs" "\$@"
	EOF
	chmod 0755 "$YARN_BIN/yarn"
	export PATH="$YARN_BIN:$PATH"

	# Patch hardcoded Docker paths (/opt/app, /opt/data, and UI About page)
	sed -i "s|/opt/app/apps/server|${TERMUX_PREFIX}/lib/maintainerr/apps/server|g" apps/server/src/app/config/typeOrmConfig.ts
	sed -i "s|/opt/data|${TERMUX_PREFIX}/var/lib/maintainerr|g" apps/server/src/app/config/dataDir.ts
	sed -i "s|'/opt/data'|process.env.DATA_DIR \|\| '${TERMUX_PREFIX}/var/lib/maintainerr'|g" apps/server/src/modules/logging/logs.module.ts
	sed -i "s|'/opt/data/logs'|(process.env.DATA_DIR ? path.join(process.env.DATA_DIR, 'logs') : '${TERMUX_PREFIX}/var/lib/maintainerr/logs')|g" apps/server/src/modules/logging/logs.controller.ts
	sed -i "s|/opt/data|~/.config/maintainerr|g" apps/ui/src/components/Settings/About/index.tsx

	# Setup cross-compilation environment for node-gyp (canvas, better-sqlite3, sharp, etc.)
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

	# Force sharp to compile against system libvips using pkg-config
	export SHARP_FORCE_GLOBAL_LIBVIPS=1

	# Prevent cypress binary download if any
	export CYPRESS_INSTALL_BINARY=0

	# Install dependencies
	yarn install --network-timeout 99999999
}

termux_step_make() {
	termux_setup_nodejs
	export PATH="$TERMUX_PKG_TMPDIR/bin:$TERMUX_PKG_SRCDIR/node_modules/.bin:$PATH"

	# Build all workspace packages (contracts, ui, server)
	yarn turbo build
}

termux_step_make_install() {
	termux_setup_nodejs
	export PATH="$TERMUX_PKG_TMPDIR/bin:$TERMUX_PKG_SRCDIR/node_modules/.bin:$PATH"

	# Clean up devDependencies before packaging
	yarn workspaces focus --all --production

	# Setup cross-compilation environment variables
	local GYP_ARCH
	case "$TERMUX_ARCH" in
	aarch64) GYP_ARCH="arm64" ;;
	arm) GYP_ARCH="arm" ;;
	i686) GYP_ARCH="ia32" ;;
	x86_64) GYP_ARCH="x64" ;;
	esac

	# Compile better-sqlite3 for target architecture in production node_modules
	(
		cd node_modules/better-sqlite3
		npm_config_arch=$GYP_ARCH npm_config_platform=android "${TERMUX_PKG_SRCDIR}/node_modules/.bin/node-gyp" rebuild --release --force_build=1
	)

	# Patch sharp libvips.cjs to strictly use Termux PKG_CONFIG_PATH instead of host /usr paths
	sed -i 's/getBrewPkgConfigPath(),//g' node_modules/sharp/dist/libvips.cjs
	sed -i 's/getPkgConfigPath(),//g' node_modules/sharp/dist/libvips.cjs

	# Compile sharp native addon against system libvips
	(
		cd node_modules/sharp
		PATH="${TERMUX_PKG_SRCDIR}/node_modules/.bin:$PATH" \
		npm_config_arch=$GYP_ARCH npm_config_platform=android \
		node install/build.js
	)

	rm -rf "${TERMUX_PREFIX}/lib/maintainerr"
	mkdir -p "${TERMUX_PREFIX}/lib/maintainerr"

	# Copy root dependencies and metadata
	cp -r node_modules "${TERMUX_PREFIX}/lib/maintainerr/"
	cp package.json "${TERMUX_PREFIX}/lib/maintainerr/"

	# Copy apps/server
	mkdir -p "${TERMUX_PREFIX}/lib/maintainerr/apps/server"
	cp -r apps/server/dist "${TERMUX_PREFIX}/lib/maintainerr/apps/server/"
	cp -r apps/server/assets "${TERMUX_PREFIX}/lib/maintainerr/apps/server/dist/assets"
	cp -r apps/ui/dist "${TERMUX_PREFIX}/lib/maintainerr/apps/server/dist/ui"
	cp apps/server/package.json "${TERMUX_PREFIX}/lib/maintainerr/apps/server/"
	if [ -d apps/server/node_modules ]; then
		cp -r apps/server/node_modules "${TERMUX_PREFIX}/lib/maintainerr/apps/server/"
	fi

	# Copy packages/contracts
	mkdir -p "${TERMUX_PREFIX}/lib/maintainerr/packages/contracts"
	cp -r packages/contracts/dist "${TERMUX_PREFIX}/lib/maintainerr/packages/contracts/"
	cp packages/contracts/package.json "${TERMUX_PREFIX}/lib/maintainerr/packages/contracts/"
	if [ -d packages/contracts/node_modules ]; then
		cp -r packages/contracts/node_modules "${TERMUX_PREFIX}/lib/maintainerr/packages/contracts/"
	fi

	# Remove incompatible host prebuilds bundled in better-sqlite3 and @img
	rm -rf "${TERMUX_PREFIX}/lib/maintainerr/node_modules/better-sqlite3/prebuilds"
	rm -rf "${TERMUX_PREFIX}/lib/maintainerr/node_modules/@img/sharp-libvips-"*
	rm -rf "${TERMUX_PREFIX}/lib/maintainerr/node_modules/@img/sharp-"*

	# Remove useless dev/doc files from node_modules to reduce package size
	find "${TERMUX_PREFIX}/lib/maintainerr" -type f \( \
		-name "*.md" -o \
		-name "*.map" -o \
		-name "*.ts" -o \
		-name "*.tsx" -o \
		-name "LICENSE" -o \
		-name "license" -o \
		-name "Makefile" \
		\) -delete

	find "${TERMUX_PREFIX}/lib/maintainerr" -type d \( \
		-name "test" -o \
		-name "tests" -o \
		-name "__tests__" -o \
		-name "docs" -o \
		-name "example" -o \
		-name "examples" -o \
		-name ".github" -o \
		-name ".circleci" -o \
		-name ".husky" \
		\) -exec rm -rf {} +

	# Strip native Node.js binaries, ignoring non-ELF formats like macOS Mach-O
	find "${TERMUX_PREFIX}/lib/maintainerr" -name "*.node" -exec sh -c '${STRIP} --strip-unneeded "$1" 2>/dev/null || true' _ {} \;

	# Remove native build intermediate objects and static archives to save space
	find "${TERMUX_PREFIX}/lib/maintainerr" -type d -name "obj.target" -exec rm -rf {} +
	find "${TERMUX_PREFIX}/lib/maintainerr" -type f \( -name "*.a" -o -name "*.la" \) -delete

	# Create launch script
	cat >"${TERMUX_PREFIX}/bin/maintainerr" <<-HERE
		#!${TERMUX_PREFIX}/bin/sh
		export DATA_DIR="\${DATA_DIR:-\$HOME/.config/maintainerr}"
		export UI_PORT="\${UI_PORT:-6246}"
		export UI_HOSTNAME="\${UI_HOSTNAME:-0.0.0.0}"
		export NODE_ENV=production
		export VERSION_TAG="stable"
		export UV_USE_IO_URING=0
		mkdir -p "\$DATA_DIR/logs"
		cd "${TERMUX_PREFIX}/lib/maintainerr/apps/server" || exit 1
		npm_package_version="\$(node -p "require('./package.json').version" 2>/dev/null)"
		export npm_package_version
		exec node dist/main "\$@"
	HERE
	chmod u+x "${TERMUX_PREFIX}/bin/maintainerr"
}
