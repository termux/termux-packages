TERMUX_PKG_HOMEPAGE=https://github.com/ULTRAXAS/xro
TERMUX_PKG_DESCRIPTION="Xro 8.6 autonomous AI coding agent CLI by ULTRAXAS"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE, NOTICE, opentui-native/LICENSE"
TERMUX_PKG_MAINTAINER="ULTRAXAS <contact@ultraxas.com>"
TERMUX_PKG_VERSION="3.0.1"
TERMUX_PKG_SRCURL="https://github.com/ULTRAXAS/xro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2b6217311863d822091f5bdeff5f78a3737d7a46b2753972bb9f77d97b06f9a4
TERMUX_PKG_DEPENDS="bun"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true

# Prebuilt OpenTUI native library (MIT, https://github.com/anomalyco/opentui)
# from the musl variant on npm. It only needs a few libc symbols that bionic
# lacks, which opentui-bionic-compat.c provides.
_OPENTUI_VERSION="0.4.3"

termux_step_post_get_source() {
	# Only the CLI is packaged: drop the VS Code extension, examples,
	# evals, documentation and other monorepo bulk before installing deps.
	rm -rf docs evals apps/vscode apps/vscode-rollout apps/examples sdk/examples \
		.agents .changeset .claude .cline .clinerules .codex .github .greptile \
		.husky .kanban .vscode
	jq '.workspaces = ["sdk/packages/*", "apps/cli", "apps/cline-hub", "apps/cline-hub/src/webview"]
		| del(.scripts.prepare)' package.json > package.json.tmp
	mv package.json.tmp package.json

	local _arch _sha256
	case "$TERMUX_ARCH" in
		aarch64)
			_arch=arm64
			_sha256=3d387c56849d214fb0db59790d4fe38d25fe6635345aa3b2e022e5195982e419
			;;
		x86_64)
			_arch=x64
			_sha256=eda098be71c4a4e3260dde0c6e51813f6a3feb14380c813dbb7d0bb865dcdf01
			;;
		*) termux_error_exit "Unsupported arch: $TERMUX_ARCH" ;;
	esac
	local _tarball="$TERMUX_PKG_CACHEDIR/opentui-core-linux-${_arch}-musl-${_OPENTUI_VERSION}.tgz"
	termux_download \
		"https://registry.npmjs.org/@opentui/core-linux-${_arch}-musl/-/core-linux-${_arch}-musl-${_OPENTUI_VERSION}.tgz" \
		"$_tarball" \
		"$_sha256"
	mkdir -p opentui-native
	tar -xzf "$_tarball" --strip-components=1 -C opentui-native
}

termux_step_make() {
	termux_setup_bun

	bun install
	bun --production -F './sdk/packages/*' build
	bun -F @cline/cline-hub build:webview

	local _arch=arm64 _other_arch=x64
	if [[ "$TERMUX_ARCH" == "x86_64" ]]; then
		_arch=x64
		_other_arch=arm64
	fi

	# Make only the target arch's native package resolvable for the bundler.
	rm -rf node_modules/@opentui/core-linux-${_arch}-musl
	mkdir -p node_modules/@opentui
	cp -a opentui-native node_modules/@opentui/core-linux-${_arch}-musl

	# Bun reports process.platform as "android" on Termux: use the
	# Linux (musl) native package there.
	local _opentui_js
	_opentui_js="$(grep -l 'async function resolveNativePackage' \
		node_modules/.bun/@opentui+core@${_OPENTUI_VERSION}*/node_modules/@opentui/core/index-*.js)"
	[[ -n "$_opentui_js" ]] || termux_error_exit "OpenTUI native resolver not found"
	sed -i \
		-e 's/if (process.platform === "linux") {/if (process.platform === "linux" || process.platform === "android") {/' \
		-e 's/if (process.env.OPENTUI_LIBC === "musl") {/if (process.platform === "android" || process.env.OPENTUI_LIBC === "musl") {/' \
		"$_opentui_js"
	grep -q 'process.platform === "android" || process.env.OPENTUI_LIBC' "$_opentui_js" ||
		termux_error_exit "Failed to patch OpenTUI native resolver"

	local -a _bun_args=(
		--target=bun
		--minify
		--outdir="$TERMUX_PKG_SRCDIR/dist-termux"
		--public-path="$TERMUX_PREFIX/lib/xro/"
		--external=@anthropic-ai/vertex-sdk
		--define 'process.env.NODE_ENV="production"'
	)
	local _p _v
	for _p in darwin-x64 darwin-arm64 win32-x64 win32-arm64 linux-x64 linux-arm64 "linux-${_other_arch}-musl"; do
		_bun_args+=(--external="@opentui/core-${_p}")
	done
	for _v in TELEMETRY_SERVICE_API_KEY ERROR_SERVICE_API_KEY OTEL_TELEMETRY_ENABLED \
		OTEL_LOGS_EXPORTER OTEL_METRICS_EXPORTER OTEL_TRACES_EXPORTER \
		CLINE_TRACE_SAMPLE_PERCENT CLINE_TRACE_RECORD_CONTENT \
		OTEL_EXPORTER_OTLP_PROTOCOL OTEL_EXPORTER_OTLP_ENDPOINT OTEL_EXPORTER_OTLP_HEADERS; do
		_bun_args+=(--define "process.env.${_v}=\"\"")
	done
	rm -rf dist-termux
	(cd apps/cli && bun build src/index.ts "${_bun_args[@]}")

	$CC $CFLAGS $CPPFLAGS -fPIC -shared $LDFLAGS \
		"$TERMUX_PKG_BUILDER_DIR/opentui-bionic-compat.c" \
		-ldl -o dist-termux/libxro-opentui-compat.so
}

termux_step_make_install() {
	install -d "$TERMUX_PREFIX/lib/xro"
	cp -a dist-termux/. "$TERMUX_PREFIX/lib/xro/"

	local _lib
	_lib="$(find "$TERMUX_PREFIX/lib/xro" -maxdepth 1 -name 'libopentui-*.so')"
	[[ -f "$_lib" ]] || termux_error_exit "OpenTUI native library missing from bundle"
	patchelf --add-needed libxro-opentui-compat.so \
		--add-needed libm.so --add-needed libdl.so \
		--set-rpath "$TERMUX_PREFIX/lib/xro" "$_lib"

	install -Dm644 sdk/packages/core/dist/extensions/plugin-sandbox-bootstrap.js \
		"$TERMUX_PREFIX/lib/xro/extensions/plugin-sandbox-bootstrap.js"
	install -d "$TERMUX_PREFIX/lib/xro/cline-hub"
	cp -a apps/cline-hub/dist/webview "$TERMUX_PREFIX/lib/xro/cline-hub/"
	install -Dm644 apps/cli/node_modules/@opentui/core/parser.worker.js \
		"$TERMUX_PREFIX/lib/xro/parser.worker.js"

	cat > "$TERMUX_PREFIX/bin/xro" <<-EOF
		#!${TERMUX_PREFIX}/bin/sh
		exec bun "${TERMUX_PREFIX}/lib/xro/index.js" "\$@"
	EOF
	chmod 755 "$TERMUX_PREFIX/bin/xro"
}
