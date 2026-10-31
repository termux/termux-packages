TERMUX_PKG_HOMEPAGE=https://github.com/yuku-toolchain/yuku
TERMUX_PKG_DESCRIPTION="High-performance JavaScript/TypeScript parser and codegen toolchain"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19.0"
TERMUX_PKG_SRCURL=https://github.com/yuku-toolchain/yuku/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81f8015d458307f537865259604ee1ac6e169850ac6c280f4406387285ee613b
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local NAPI_ZIG_COMMIT="2ef8928d9cdf70af1cc6b17928f506c0a5ca0076"
	local NAPI_ZIG_URL="https://github.com/yuku-toolchain/napi-zig/archive/${NAPI_ZIG_COMMIT}.tar.gz"
	local NAPI_ZIG_SHA256="a50c06da9bcf561c06aef23ccd24021546b9ec15e2a45861989b263db25afe49"

	# Download napi-zig source
	termux_download "${NAPI_ZIG_URL}" "${TERMUX_PKG_CACHEDIR}/napi-zig-${NAPI_ZIG_COMMIT}.tar.gz" "${NAPI_ZIG_SHA256}"
	tar -xf "${TERMUX_PKG_CACHEDIR}/napi-zig-${NAPI_ZIG_COMMIT}.tar.gz"
	mv -v "napi-zig-${NAPI_ZIG_COMMIT}" "napi-zig-src"

	# Patch build.zig.zon to point to local napi-zig-src
	sed -i "s|.url = \"git+https://github.com/yuku-toolchain/napi-zig?ref=main#${NAPI_ZIG_COMMIT}\"|.path = \"napi-zig-src\"|g" build.zig.zon
	# Remove the hash entry since local path dependencies don't have/need a hash
	sed -i '/.hash = "napi_zig-0.2.0-XRkY0UsWAgAqaAoq4Zx7sCD39BNi-Uiq0uMS8sIX_ZUZ",/d' build.zig.zon
}

termux_step_pre_configure() {
	termux_setup_zig
	termux_setup_nodejs
}

termux_step_make() {
	# Generate pnpm-workspace.yaml since pnpm doesn't read package.json workspaces by default
	cat <<-EOF >pnpm-workspace.yaml
		packages:
		  - 'npm/**/*'
	EOF

	# Install dependencies using pnpm to support the workspace: protocol
	npx --yes pnpm install --no-frozen-lockfile --ignore-scripts

	# Generate JS AST definitions
	zig build gen-token-types gen-parser-decoder gen-analyzer-decoder gen-walk-tables

	# Copy the generated files
	cp ./zig-out/tokens.d.ts ./npm/yuku-types/
	cp ./zig-out/decode.js ./npm/yuku-parser/
	cp ./zig-out/decode-analyzer.js ./npm/yuku-analyzer/decode.js
	cp ./zig-out/walk-tables.ts ./npm/yuku-ast/src/generated.ts

	# Compile TS for yuku-ast and yuku-codegen using pnpm workspace runner
	npx --yes pnpm --filter yuku-ast run build
	npx --yes pnpm --filter yuku-codegen run build

	# Build native library against bionic, as the addon is loaded by Android's node
	local ZIG_ANDROID_TARGET="$TERMUX_HOST_PLATFORM.$TERMUX_PKG_API_LEVEL"
	[[ "$TERMUX_ARCH" == "i686" ]] && ZIG_ANDROID_TARGET="x86-linux-android.$TERMUX_PKG_API_LEVEL"
	local LIBC_FILE="$TERMUX_PKG_TMPDIR/libc.txt"
	cat <<-EOF >"$LIBC_FILE"
		include_dir=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include
		sys_include_dir=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$TERMUX_HOST_PLATFORM
		crt_dir=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL
		cc_dir=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL
		msvc_lib_dir=
		kernel32_lib_dir=
		darwin_sdk_dir=
	EOF
	zig build -Dtarget="$ZIG_ANDROID_TARGET" -Doptimize=ReleaseFast -Dlibc-file="$LIBC_FILE" --libc "$LIBC_FILE"
}

termux_step_make_install() {
	local INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules"
	mkdir -p "$INSTALL_DIR"

	local YUKU_ARCH=""
	case "$TERMUX_ARCH" in
	aarch64) YUKU_ARCH="arm64" ;;
	arm) YUKU_ARCH="arm" ;;
	i686) YUKU_ARCH="ia32" ;;
	x86_64) YUKU_ARCH="x64" ;;
	esac

	# Install yuku-core
	mkdir -p "$INSTALL_DIR/yuku-core/@yuku-core/binding-android-$YUKU_ARCH"
	cp npm/yuku-core/package.json npm/yuku-core/index.js npm/yuku-core/index.d.ts npm/yuku-core/binding.js npm/yuku-core/browser.js npm/yuku-core/options.js "$INSTALL_DIR/yuku-core/"
	cp zig-out/lib/yuku-core.node "$INSTALL_DIR/yuku-core/@yuku-core/binding-android-$YUKU_ARCH/yuku-core.node"
	cat <<-EOF >"$INSTALL_DIR/yuku-core/@yuku-core/binding-android-$YUKU_ARCH/package.json"
		{
		  "name": "@yuku-core/binding-android-$YUKU_ARCH",
		  "version": "$TERMUX_PKG_VERSION",
		  "os": ["android"],
		  "cpu": ["$YUKU_ARCH"],
		  "main": "yuku-core.node",
		  "files": ["yuku-core.node"]
		}
	EOF

	# Install yuku-parser
	mkdir -p "$INSTALL_DIR/yuku-parser"
	cp npm/yuku-parser/package.json npm/yuku-parser/index.js npm/yuku-parser/index.d.ts npm/yuku-parser/decode.js "$INSTALL_DIR/yuku-parser/"

	# Install yuku-analyzer
	mkdir -p "$INSTALL_DIR/yuku-analyzer"
	cp npm/yuku-analyzer/package.json npm/yuku-analyzer/index.js npm/yuku-analyzer/index.d.ts npm/yuku-analyzer/analyzer.js npm/yuku-analyzer/module.js npm/yuku-analyzer/decode.js "$INSTALL_DIR/yuku-analyzer/"

	# Install yuku-codegen
	mkdir -p "$INSTALL_DIR/yuku-codegen"
	cp -r npm/yuku-codegen/package.json npm/yuku-codegen/dist "$INSTALL_DIR/yuku-codegen/"

	# Install yuku-ast
	mkdir -p "$INSTALL_DIR/yuku-ast"
	cp -r npm/yuku-ast/package.json npm/yuku-ast/dist "$INSTALL_DIR/yuku-ast/"

	# Install types
	mkdir -p "$INSTALL_DIR/@yuku-toolchain/types"
	cp npm/yuku-types/package.json npm/yuku-types/index.d.ts npm/yuku-types/tokens.d.ts "$INSTALL_DIR/@yuku-toolchain/types/"

	# Symlink workspace dependencies for local node resolution
	local pkg
	for pkg in yuku-core yuku-parser yuku-analyzer yuku-codegen yuku-ast; do
		mkdir -p "$INSTALL_DIR/$pkg/node_modules/@yuku-toolchain"
		ln -sf "$INSTALL_DIR/@yuku-toolchain/types" "$INSTALL_DIR/$pkg/node_modules/@yuku-toolchain/types"
	done
	for pkg in yuku-parser yuku-analyzer; do
		ln -sf "$INSTALL_DIR/yuku-core" "$INSTALL_DIR/$pkg/node_modules/yuku-core"
	done
	ln -sf "$INSTALL_DIR/yuku-ast" "$INSTALL_DIR/yuku-analyzer/node_modules/yuku-ast"
}
