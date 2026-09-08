TERMUX_PKG_HOMEPAGE=https://rolldown.rs/
TERMUX_PKG_DESCRIPTION="Fast JavaScript/TypeScript bundler in Rust with Rollup-compatible API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.4"
TERMUX_PKG_SRCURL=https://github.com/rolldown/rolldown/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=758466a4160a27e46628e1b2385bf59dfa2ff5907fff4b6acd65ddc844196510
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="nodejs, yuku"
# TERMUX_PKG_EXCLUDED_ARCHES="arm, i686, x86_64"

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

	# Determine target architectures
	local NAPI_ARCH=""
	case "$TERMUX_ARCH" in
		aarch64) NAPI_ARCH="arm64" ;;
		arm) NAPI_ARCH="arm-eabi" ;;
		i686) NAPI_ARCH="ia32" ;;
		x86_64) NAPI_ARCH="x64" ;;
	esac

	# Copy native binding to src directory before JS build
	mkdir -p packages/rolldown/src packages/rolldown/dist packages/rolldown/dist/shared
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown/src/rolldown-binding.android-$NAPI_ARCH.node"
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown/dist/rolldown-binding.android-$NAPI_ARCH.node"
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown/dist/shared/rolldown-binding.android-$NAPI_ARCH.node"

	# Patch binding.cjs to add support for Android x64 and ia32 architectures
	cat <<-'EOF' > patch_binding.cjs
	const fs = require('fs');
	const pkg = JSON.parse(fs.readFileSync('packages/rolldown/package.json', 'utf8'));
	const version = pkg.version;
	const file = 'packages/rolldown/src/binding.cjs';
	if (fs.existsSync(file)) {
		let content = fs.readFileSync(file, 'utf8').replace(/\r\n/g, '\n');
		const androidBlockRegex = /  \} else if \(process\.platform === 'android'\) \{[\s\S]*?\} else if \(process\.platform === 'win32'\) \{/;
		const patch = `  } else if (process.platform === 'android') {
    if (process.arch === 'arm64') {
      try {
        return require('./rolldown-binding.android-arm64.node')
      } catch (e) {
        loadErrors.push(e)
      }
      try {
        const binding = require('@rolldown/binding-android-arm64')
        const bindingPackageVersion = require('@rolldown/binding-android-arm64/package.json').version
        if (bindingPackageVersion !== '${version}' && process.env.NAPI_RS_ENFORCE_VERSION_CHECK && process.env.NAPI_RS_ENFORCE_VERSION_CHECK !== '0') {
          throw new Error(\`Native binding package version mismatch, expected ${version} but got \\\${bindingPackageVersion}. You can reinstall dependencies to fix this issue.\`)
        }
        return binding
      } catch (e) {
        loadErrors.push(e)
      }
    } else if (process.arch === 'arm') {
      try {
        return require('./rolldown-binding.android-arm-eabi.node')
      } catch (e) {
        loadErrors.push(e)
      }
      try {
        const binding = require('@rolldown/binding-android-arm-eabi')
        const bindingPackageVersion = require('@rolldown/binding-android-arm-eabi/package.json').version
        if (bindingPackageVersion !== '${version}' && process.env.NAPI_RS_ENFORCE_VERSION_CHECK && process.env.NAPI_RS_ENFORCE_VERSION_CHECK !== '0') {
          throw new Error(\`Native binding package version mismatch, expected ${version} but got \\\${bindingPackageVersion}. You can reinstall dependencies to fix this issue.\`)
        }
        return binding
      } catch (e) {
        loadErrors.push(e)
      }
    } else if (process.arch === 'x64') {
      try {
        return require('./rolldown-binding.android-x64.node')
      } catch (e) {
        loadErrors.push(e)
      }
      try {
        const binding = require('@rolldown/binding-android-x64')
        const bindingPackageVersion = require('@rolldown/binding-android-x64/package.json').version
        if (bindingPackageVersion !== '${version}' && process.env.NAPI_RS_ENFORCE_VERSION_CHECK && process.env.NAPI_RS_ENFORCE_VERSION_CHECK !== '0') {
          throw new Error(\`Native binding package version mismatch, expected ${version} but got \\\${bindingPackageVersion}. You can reinstall dependencies to fix this issue.\`)
        }
        return binding
      } catch (e) {
        loadErrors.push(e)
      }
    } else if (process.arch === 'ia32') {
      try {
        return require('./rolldown-binding.android-ia32.node')
      } catch (e) {
        loadErrors.push(e)
      }
      try {
        const binding = require('@rolldown/binding-android-ia32')
        const bindingPackageVersion = require('@rolldown/binding-android-ia32/package.json').version
        if (bindingPackageVersion !== '${version}' && process.env.NAPI_RS_ENFORCE_VERSION_CHECK && process.env.NAPI_RS_ENFORCE_VERSION_CHECK !== '0') {
          throw new Error(\`Native binding package version mismatch, expected ${version} but got \\\${bindingPackageVersion}. You can reinstall dependencies to fix this issue.\`)
        }
        return binding
      } catch (e) {
        loadErrors.push(e)
      }
    } else {
      loadErrors.push(new Error(\`Unsupported architecture on Android \\\${process.arch}\`))
    }
  } else if (process.platform === 'win32') {`;
		const originalMatch = content.match(androidBlockRegex);
		if (!originalMatch) {
			console.error('FATAL: android block pattern not found in binding.cjs — upstream layout changed, patch needs updating');
			process.exit(1);
		}
		content = content.replace(androidBlockRegex, patch);
		fs.writeFileSync(file, content, 'utf8');
	} else {
		console.error('FATAL: packages/rolldown/src/binding.cjs does not exist');
		process.exit(1);
	}
	EOF
	node patch_binding.cjs || exit 1
	rm -f patch_binding.cjs

	# Install host native binding so the JS build runner can execute on the build host
	npx --yes pnpm add -w --ignore-scripts @rolldown/binding-linux-x64-gnu

	# Stub defineConfig in vite.config.ts to avoid loading vite-plus
	sed -i "s/import { defineConfig } from 'vite-plus';/export const defineConfig = (config) => config;/g" vite.config.ts

	# Build JS glue
	npx --yes pnpm --filter rolldown run build-js-glue

	# Deploy package for self-contained installation (production only)
	echo "force-legacy-deploy=true" >> .npmrc
	npx --yes pnpm --filter=./packages/rolldown deploy --legacy --ignore-scripts packages/rolldown-deploy

	# Copy native binding to deployed dist since files pattern in package.json excludes *.node
	mkdir -p packages/rolldown-deploy/dist packages/rolldown-deploy/dist/shared
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown-deploy/dist/rolldown-binding.android-$NAPI_ARCH.node"
	cp "target/$CARGO_TARGET_NAME/release/librolldown_binding.so" "packages/rolldown-deploy/dist/shared/rolldown-binding.android-$NAPI_ARCH.node"

	# Replace deployed yuku dependencies with symlinks to the system prefix
	rm -rf packages/rolldown-deploy/node_modules/yuku-codegen packages/rolldown-deploy/node_modules/yuku-parser
	ln -sf "$TERMUX_PREFIX/lib/node_modules/yuku-codegen" packages/rolldown-deploy/node_modules/yuku-codegen
	ln -sf "$TERMUX_PREFIX/lib/node_modules/yuku-parser" packages/rolldown-deploy/node_modules/yuku-parser
}

termux_step_make_install() {
	local INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/rolldown"
	mkdir -p "$INSTALL_DIR"
	cp -r packages/rolldown-deploy/* "$INSTALL_DIR/"

	# Install CLI binary symlink
	install -Dm755 packages/rolldown-deploy/bin/cli.mjs "$INSTALL_DIR/bin/cli.mjs"
	ln -sf "$INSTALL_DIR/bin/cli.mjs" "$TERMUX_PREFIX/bin/rolldown"
}
