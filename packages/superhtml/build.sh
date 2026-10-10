TERMUX_PKG_HOMEPAGE="https://github.com/kristoff-it/superhtml"
TERMUX_PKG_DESCRIPTION="A HTML language server and templating engine formatter/linter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL="git+https://github.com/kristoff-it/superhtml"
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_zig

	# Fetch Zig dependencies
	zig build --fetch

	# Patch tracy
	local tracy_dir
	tracy_dir=$(find "${TERMUX_PKG_SRCDIR}/zig-pkg" "${TERMUX_PKG_BUILDDIR}/.zig-cache/p" "${HOME}/.cache/zig/p" -maxdepth 1 -name "tracy-*" 2>/dev/null | head -n 1 || true)
	if [[ -n "${tracy_dir}" && -d "${tracy_dir}" ]]; then
		patch -d "${tracy_dir}" -p1 -N -r - < "${TERMUX_PKG_BUILDER_DIR}/tracy.diff" || true
	fi

	# Patch lsp_kit and copy metaModel.json to src/codegen
	local lsp_kit_dir
	lsp_kit_dir=$(find "${TERMUX_PKG_SRCDIR}/zig-pkg" "${TERMUX_PKG_BUILDDIR}/.zig-cache/p" "${HOME}/.cache/zig/p" -maxdepth 1 -name "lsp_kit-*" 2>/dev/null | head -n 1 || true)
	if [[ -n "${lsp_kit_dir}" && -d "${lsp_kit_dir}" ]]; then
		if [[ -f "${lsp_kit_dir}/metaModel.json" && ! -f "${lsp_kit_dir}/src/codegen/metaModel.json" ]]; then
			cp "${lsp_kit_dir}/metaModel.json" "${lsp_kit_dir}/src/codegen/metaModel.json"
		fi
		patch -d "${lsp_kit_dir}" -p1 -N -r - < "${TERMUX_PKG_BUILDER_DIR}/lsp_kit.diff" || true
	fi

	# Build superhtml
	zig build \
		-Dtarget="${ZIG_TARGET_NAME}" \
		-Doptimize=ReleaseSafe
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" zig-out/bin/superhtml
}
