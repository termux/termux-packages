TERMUX_PKG_HOMEPAGE="https://github.com/seerr-team/seerr"
TERMUX_PKG_DESCRIPTION="A fork of Overseerr with focus on adding support for Jellyfin/Emby"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.0"
TERMUX_PKG_SRCURL="https://github.com/seerr-team/seerr/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="3a6caf9266f7525c3ac2aecb666f5939034e383296761bdea14ad3105237721c"
TERMUX_PKG_BUILD_DEPENDS="nodejs, libvips, pkg-config"
TERMUX_PKG_DEPENDS="nodejs, libvips, termux-services"
# Uncomment the line below to avoid file conflicts when building on-device
# while other background services are actively writing logs (system-level bug #30401)
# TERMUX_PKG_RM_AFTER_INSTALL="var/log"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SERVICE_SCRIPT=(
	"seerr"
	"exec ${TERMUX_PREFIX}/bin/seerr 2>&1"
)

termux_step_pre_configure() {
	termux_setup_nodejs

	# Install pnpm locally in a clean prefix to avoid dependency resolution conflicts with package.json
	local PNPM_DIR="$TERMUX_PKG_TMPDIR/pnpm"
	mkdir -p "$PNPM_DIR"
	npm install --prefix "$PNPM_DIR" pnpm
	export PATH="$PNPM_DIR/node_modules/.bin:$PATH"

	# Loosen node engine requirements in package.json
	sed -i '/"engines": {/,/}/ s/"node": ".*"/"node": ">=20.0.0"/' package.json

	# Setup cross-compilation environment for node-gyp (sqlite3, bcrypt, etc.)
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

	# Cypress binary download is not needed for packaging
	export CYPRESS_INSTALL_BINARY=0

	# Install dependencies
	pnpm install --frozen-lockfile=false --no-engine-strict

	# Add SWC WASM loader node package matching the next.js version
	local NEXT_VERSION=$(node -p "require('./package.json').dependencies.next")
	pnpm add "@next/swc-wasm-nodejs@$NEXT_VERSION"

	# Patch Next.js SWC loader for WASM fallback
	local INDEX_JS="node_modules/next/dist/build/swc/index.js"
	if [ -f "$INDEX_JS" ]; then
		sed -i 's/const isWebContainer = .*;/const isWebContainer = true;/g' "$INDEX_JS"
	fi

	# Disable swcMinify in config file to prevent build issues
	local CONFIG_FILE=""
	if [ -f "next.config.ts" ]; then
		CONFIG_FILE="next.config.ts"
	elif [ -f "next.config.js" ]; then
		CONFIG_FILE="next.config.js"
	fi

	if [ -n "$CONFIG_FILE" ]; then
		if ! grep -q "swcMinify: false" "$CONFIG_FILE"; then
			if grep -q "const nextConfig: NextConfig = {" "$CONFIG_FILE"; then
				sed -i 's/const nextConfig: NextConfig = {/const nextConfig: NextConfig = {\n  swcMinify: false,/' "$CONFIG_FILE"
			elif grep -q "module.exports = {" "$CONFIG_FILE"; then
				sed -i 's/module.exports = {/module.exports = {\n  swcMinify: false,/' "$CONFIG_FILE"
			fi
		fi
	fi

	# Force Next.js to use Webpack instead of Turbopack (the default in Next.js 16).
	# Turbopack's runtime dynamically generates relative symlinks in .next/node_modules/
	# pointing back to the temporary build directory, which go dead once relocated to
	# $TERMUX_PREFIX for packaging (upstream bug: vercel/next.js#89851).
	sed -i 's/"build:next": "next build"/"build:next": "next build --webpack"/g' package.json
}

termux_step_make() {
	termux_setup_nodejs
	export PATH="$TERMUX_PKG_TMPDIR/pnpm/node_modules/.bin:$TERMUX_PKG_SRCDIR/node_modules/.bin:$PATH"
	pnpm build
}

termux_step_make_install() {
	termux_setup_nodejs
	# Clean up devDependencies before packaging
	export PATH="$TERMUX_PKG_TMPDIR/pnpm/node_modules/.bin:$TERMUX_PKG_SRCDIR/node_modules/.bin:$PATH"
	pnpm prune --prod --ignore-scripts

	rm -rf "${TERMUX_PREFIX}/lib/seerr"
	mkdir -p "${TERMUX_PREFIX}/lib/seerr"

	# Copy build artifacts, public assets, and runtime dependencies
	cp -r dist "${TERMUX_PREFIX}/lib/seerr/"
	cp -r public "${TERMUX_PREFIX}/lib/seerr/"
	cp -r .next "${TERMUX_PREFIX}/lib/seerr/"
	cp -r node_modules "${TERMUX_PREFIX}/lib/seerr/"
	cp package.json seerr-api.yml "${TERMUX_PREFIX}/lib/seerr/"

	# Remove Next.js build cache (only used at compilation time, not runtime)
	rm -rf "${TERMUX_PREFIX}/lib/seerr/.next/cache"

	# Remove useless dev/doc files from node_modules to reduce package size
	find "${TERMUX_PREFIX}/lib/seerr/node_modules" -type f \( \
		-name "*.md" -o \
		-name "*.map" -o \
		-name "*.ts" -o \
		-name "*.tsx" -o \
		-name "LICENSE" -o \
		-name "license" -o \
		-name "Makefile" \
	\) -delete

	find "${TERMUX_PREFIX}/lib/seerr/node_modules" -type d \( \
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

	# Strip native Node.js binaries, ignoring non-ELF formats like macOS Mach-O
	find "${TERMUX_PREFIX}/lib/seerr/node_modules" -name "*.node" -exec sh -c '${STRIP} --strip-unneeded "$1" 2>/dev/null || true' _ {} \;

	# Remove native build intermediate objects to save space
	find "${TERMUX_PREFIX}/lib/seerr/node_modules" -type d -name "obj.target" -exec rm -rf {} +

	# Create launch script
	cat > "${TERMUX_PREFIX}/bin/seerr" <<-HERE
		#!${TERMUX_PREFIX}/bin/sh
		export CONFIG_DIRECTORY="\${CONFIG_DIRECTORY:-\$HOME/.config/seerr}"
		export PORT="\${PORT:-5055}"
		export NODE_ENV=production
		cd "${TERMUX_PREFIX}/lib/seerr"
		exec node dist/index.js "\$@"
	HERE
	chmod u+x "${TERMUX_PREFIX}/bin/seerr"
}
