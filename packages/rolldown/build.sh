TERMUX_PKG_HOMEPAGE=https://rolldown.rs/
TERMUX_PKG_DESCRIPTION="Fast JavaScript/TypeScript bundler in Rust with Rollup-compatible API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.3"
TERMUX_PKG_SRCURL=https://github.com/rolldown/rolldown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9975a36336117778976b2b98e834aad93272e55bccbde21df963a7862bcb4f33
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_nodejs
	termux_setup_cmake

	# Bypasses CMake NDK auto-detection for Rust's cmake crate during cross-compilation
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		export TARGET_CMAKE_TOOLCHAIN_FILE="${TERMUX_PKG_BUILDDIR}/android.toolchain.cmake"
		touch "${TARGET_CMAKE_TOOLCHAIN_FILE}"
	fi
}

termux_step_make() {
	# Install project dependencies
	npx --yes pnpm install --no-frozen-lockfile --ignore-scripts

	# Build native binding via Cargo
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release -p rolldown_binding

	# Copy native binding to src directory before JS build
	local NAPI_ARCH="arm64"
	mkdir -p packages/rolldown/src packages/rolldown/dist
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown/src/rolldown-binding.android-$NAPI_ARCH.node"
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown/dist/rolldown-binding.android-$NAPI_ARCH.node"

	# Install host native binding so the JS build runner can execute on the build host
	npx --yes pnpm add -w --ignore-scripts @rolldown/binding-linux-x64-gnu

	# Install optional native bindings for Android to make JS builds run successfully
	npx --yes pnpm add -w --ignore-scripts @yuku-codegen/binding-android-arm64 @yuku-parser/binding-android-arm64

	# Symlink optional packages into their virtual store folders so they can be resolved
	for dir in node_modules/.pnpm/yuku-codegen@*/node_modules/yuku-codegen; do
		mkdir -p "$dir/node_modules/@yuku-codegen"
		ln -sf "$(pwd)/node_modules/.pnpm/@yuku-codegen+binding-android-arm64@*/node_modules/@yuku-codegen/binding-android-arm64" "$dir/node_modules/@yuku-codegen/binding-android-arm64"
	done

	for dir in node_modules/.pnpm/yuku-parser@*/node_modules/yuku-parser; do
		mkdir -p "$dir/node_modules/@yuku-parser"
		ln -sf "$(pwd)/node_modules/.pnpm/@yuku-parser+binding-android-arm64@*/node_modules/@yuku-parser/binding-android-arm64" "$dir/node_modules/@yuku-parser/binding-android-arm64"
	done

	# Stub defineConfig in vite.config.ts to avoid loading vite-plus
	sed -i "s/import { defineConfig } from 'vite-plus';/export const defineConfig = (config) => config;/g" vite.config.ts

	# Build JS glue
	npx --yes pnpm --filter rolldown run build-js-glue

	# Deploy package for self-contained installation (production only)
	echo "force-legacy-deploy=true" >> .npmrc
	npx --yes pnpm --filter=./packages/rolldown deploy --legacy --ignore-scripts packages/rolldown-deploy

	# Copy native binding to deployed dist since files pattern in package.json excludes *.node
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown-deploy/dist/rolldown-binding.android-$NAPI_ARCH.node"
}

termux_step_make_install() {
	local INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/rolldown"
	mkdir -p "$INSTALL_DIR"
	cp -r packages/rolldown-deploy/* "$INSTALL_DIR/"

	# Install CLI binary symlink
	install -Dm755 packages/rolldown-deploy/bin/cli.mjs "$INSTALL_DIR/bin/cli.mjs"
	ln -sf "$INSTALL_DIR/bin/cli.mjs" "$TERMUX_PREFIX/bin/rolldown"
}
