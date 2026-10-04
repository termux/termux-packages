TERMUX_PKG_HOMEPAGE=https://nubjs.com
TERMUX_PKG_DESCRIPTION="The fast all-in-one Node.js toolkit: TypeScript runner, script runner and package manager on top of stock node"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.9.6"
TERMUX_PKG_SRCURL="https://github.com/nubjs/nub/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cf82aae75a8cc6193212d42298be5d0bd921ec5dc19d91120b7eb408238d62d0
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
# Upstream supports 64-bit only
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_nodejs

	# Skip primer generation (needs network)
	rm -f vendor/aube/scripts/generate-primer.mjs

	# Resolve runtime deps versions from nub.lock
	local _pkg _ver
	local -a _specs=()
	for _pkg in @oxc-project/runtime urlpattern-polyfill @js-temporal/polyfill @petamoriken/float16 jsbi; do
		_ver="$(sed -nE "s|^  '?${_pkg}@([0-9][^':]*)'?:.*|\1|p" nub.lock | head -n1)"
		[[ -n "${_ver}" ]] || termux_error_exit "Unable to find the locked version of ${_pkg} in nub.lock"
		_specs+=("${_pkg}@${_ver}")
	done

	local _deps_dir="${TERMUX_PKG_TMPDIR}/runtime-deps"
	rm -rf "${_deps_dir}"
	mkdir -p "${_deps_dir}"
	(
		cd "${_deps_dir}"
		npm init -y > /dev/null 2>&1
		# Single install to avoid pruning
		npm install --no-save --ignore-scripts --no-audit --no-fund "${_specs[@]}"
	)
	rm -f "${_deps_dir}/node_modules/.package-lock.json"
	rm -rf "${TERMUX_PKG_SRCDIR}/runtime/node_modules"
	cp -a "${_deps_dir}/node_modules" "${TERMUX_PKG_SRCDIR}/runtime/node_modules"
}

termux_step_make() {
	# Build native addon (separate workspace)
	(
		cd crates/nub-native
		cargo build \
			--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
			--locked \
			--release \
			--target "${CARGO_TARGET_NAME}"
	)

	# Build CLI (runtime installed as plain files)
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--locked \
		--release \
		--target "${CARGO_TARGET_NAME}" \
		--package nub-cli
}

termux_step_make_install() {
	local _release_dir="target/${CARGO_TARGET_NAME}/release"

	install -Dm755 "${_release_dir}/nub" "${TERMUX_PREFIX}/bin/nub"
	# nubx and nubr are symlinks to nub
	ln -sf nub "${TERMUX_PREFIX}/bin/nubx"
	ln -sf nub "${TERMUX_PREFIX}/bin/nubr"

	local _runtime_dir="${TERMUX_PREFIX}/lib/nub/runtime"
	rm -rf "${_runtime_dir}"
	mkdir -p "${_runtime_dir}"
	cp -a runtime/. "${_runtime_dir}/"
	install -Dm755 "${_release_dir}/libnub_native.so" "${_runtime_dir}/addons/nub-native.node"
}
