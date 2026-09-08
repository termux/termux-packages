TERMUX_PKG_HOMEPAGE=https://github.com/yuku-toolchain/yuku
TERMUX_PKG_DESCRIPTION="High-performance JavaScript/TypeScript parser and codegen toolchain"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.5"
TERMUX_PKG_SRCURL=https://github.com/yuku-toolchain/yuku/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3afd2b276788c6dff2dfab9a0ef767c03c049c71d1b8b08d6d399ef9ea1cf514
TERMUX_PKG_DEPENDS="nodejs"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local NAPI_ZIG_COMMIT="253f5a92b1c0c70ad13a6583993a9befb88d1116"
	local NAPI_ZIG_URL="https://github.com/yuku-toolchain/napi-zig/archive/${NAPI_ZIG_COMMIT}.tar.gz"
	local NAPI_ZIG_SHA256="e694e65fc8ff9902bb61e564bb4aa94b0a0188d650a8d2d867c469b9a44a812b"

	# Download napi-zig source
	termux_download "${NAPI_ZIG_URL}" "${TERMUX_PKG_CACHEDIR}/napi-zig-${NAPI_ZIG_COMMIT}.tar.gz" "${NAPI_ZIG_SHA256}"
	tar -xf "${TERMUX_PKG_CACHEDIR}/napi-zig-${NAPI_ZIG_COMMIT}.tar.gz"
	mv -v "napi-zig-${NAPI_ZIG_COMMIT}" "napi-zig-src"

	# Patch build.zig.zon to point to local napi-zig-src
	sed -i 's|.url = "git+https://github.com/yuku-toolchain/napi-zig?ref=HEAD#253f5a92b1c0c70ad13a6583993a9befb88d1116"|.path = "napi-zig-src"|g' build.zig.zon
	# Remove the hash entry since local path dependencies don't have/need a hash
	sed -i '/.hash = "napi_zig-0.2.0-XRkY0Y8XAgBr17lGjp5nFI-CYpmjGManq9S4TkaY-D5g",/d' build.zig.zon
}

termux_step_pre_configure() {
	termux_setup_zig
	termux_setup_nodejs
}

termux_step_make() {
	# Generate pnpm-workspace.yaml since pnpm doesn't read package.json workspaces by default
	cat <<-EOF > pnpm-workspace.yaml
	packages:
	  - 'npm/**/*'
	EOF

	# Install dependencies using pnpm to support the workspace: protocol
	npx --yes pnpm install --no-frozen-lockfile --ignore-scripts

	# Generate JS AST definitions
	zig build gen-parser-decoder
	zig build gen-analyzer-decoder
	zig build gen-codegen-encoder
	zig build gen-walk-tables

	# Copy the generated JS files
	cp ./zig-out/decode.js ./npm/yuku-parser/
	cp ./zig-out/encode.js ./npm/yuku-codegen/
	cp ./zig-out/decode-analyzer.js ./npm/yuku-analyzer/decode.js
	cp ./src/parser/ffi/analyzer.d.ts ./npm/yuku-analyzer/index.d.ts
	cp ./zig-out/walk-tables.ts ./npm/yuku-ast/src/generated.ts

	# Compile TS for yuku-ast using pnpm workspace runner
	npx --yes pnpm --filter yuku-ast run build

	# Build native libraries for target architecture
	zig build -Dtarget="$ZIG_TARGET_NAME" -Doptimize=ReleaseFast
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

	# Install yuku-codegen
	mkdir -p "$INSTALL_DIR/yuku-codegen/@yuku-codegen/binding-android-$YUKU_ARCH"
	cp npm/yuku-codegen/package.json npm/yuku-codegen/index.js npm/yuku-codegen/index.d.ts npm/yuku-codegen/binding.js npm/yuku-codegen/encode.js "$INSTALL_DIR/yuku-codegen/"
	cp zig-out/lib/yuku-codegen.node "$INSTALL_DIR/yuku-codegen/@yuku-codegen/binding-android-$YUKU_ARCH/yuku-codegen.node"
	cat <<-EOF > "$INSTALL_DIR/yuku-codegen/@yuku-codegen/binding-android-$YUKU_ARCH/package.json"
	{
	  "name": "@yuku-codegen/binding-android-$YUKU_ARCH",
	  "version": "$TERMUX_PKG_VERSION",
	  "os": ["android"],
	  "cpu": ["$YUKU_ARCH"],
	  "main": "yuku-codegen.node",
	  "files": ["yuku-codegen.node"]
	}
	EOF

	# Install yuku-parser
	mkdir -p "$INSTALL_DIR/yuku-parser/@yuku-parser/binding-android-$YUKU_ARCH"
	cp npm/yuku-parser/package.json npm/yuku-parser/index.js npm/yuku-parser/index.d.ts npm/yuku-parser/binding.js npm/yuku-parser/decode.js "$INSTALL_DIR/yuku-parser/"
	cp zig-out/lib/yuku-parser.node "$INSTALL_DIR/yuku-parser/@yuku-parser/binding-android-$YUKU_ARCH/yuku-parser.node"
	cat <<-EOF > "$INSTALL_DIR/yuku-parser/@yuku-parser/binding-android-$YUKU_ARCH/package.json"
	{
	  "name": "@yuku-parser/binding-android-$YUKU_ARCH",
	  "version": "$TERMUX_PKG_VERSION",
	  "os": ["android"],
	  "cpu": ["$YUKU_ARCH"],
	  "main": "yuku-parser.node",
	  "files": ["yuku-parser.node"]
	}
	EOF

	# Install yuku-analyzer
	mkdir -p "$INSTALL_DIR/yuku-analyzer/@yuku-analyzer/binding-android-$YUKU_ARCH"
	cp npm/yuku-analyzer/package.json npm/yuku-analyzer/index.js npm/yuku-analyzer/index.d.ts npm/yuku-analyzer/binding.js npm/yuku-analyzer/decode.js "$INSTALL_DIR/yuku-analyzer/"
	cp zig-out/lib/yuku-analyzer.node "$INSTALL_DIR/yuku-analyzer/@yuku-analyzer/binding-android-$YUKU_ARCH/yuku-analyzer.node"
	cat <<-EOF > "$INSTALL_DIR/yuku-analyzer/@yuku-analyzer/binding-android-$YUKU_ARCH/package.json"
	{
	  "name": "@yuku-analyzer/binding-android-$YUKU_ARCH",
	  "version": "$TERMUX_PKG_VERSION",
	  "os": ["android"],
	  "cpu": ["$YUKU_ARCH"],
	  "main": "yuku-analyzer.node",
	  "files": ["yuku-analyzer.node"]
	}
	EOF

	# Install yuku-ast
	mkdir -p "$INSTALL_DIR/yuku-ast"
	cp -r npm/yuku-ast/package.json npm/yuku-ast/dist "$INSTALL_DIR/yuku-ast/"

	# Install types
	mkdir -p "$INSTALL_DIR/@yuku-toolchain/types"
	cp npm/yuku-types/package.json npm/yuku-types/index.d.ts "$INSTALL_DIR/@yuku-toolchain/types/"

	# Symlink workspace dependencies for local node resolution
	mkdir -p "$INSTALL_DIR/yuku-codegen/node_modules/@yuku-toolchain"
	ln -sf "$INSTALL_DIR/@yuku-toolchain/types" "$INSTALL_DIR/yuku-codegen/node_modules/@yuku-toolchain/types"

	mkdir -p "$INSTALL_DIR/yuku-parser/node_modules/@yuku-toolchain"
	ln -sf "$INSTALL_DIR/@yuku-toolchain/types" "$INSTALL_DIR/yuku-parser/node_modules/@yuku-toolchain/types"
	ln -sf "$INSTALL_DIR/yuku-ast" "$INSTALL_DIR/yuku-parser/node_modules/yuku-ast"

	mkdir -p "$INSTALL_DIR/yuku-analyzer/node_modules/@yuku-toolchain"
	ln -sf "$INSTALL_DIR/@yuku-toolchain/types" "$INSTALL_DIR/yuku-analyzer/node_modules/@yuku-toolchain/types"
	ln -sf "$INSTALL_DIR/yuku-ast" "$INSTALL_DIR/yuku-analyzer/node_modules/yuku-ast"
}
