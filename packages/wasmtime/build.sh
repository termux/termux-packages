TERMUX_PKG_HOMEPAGE=https://wasmtime.dev/
TERMUX_PKG_DESCRIPTION="A standalone runtime for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="29.0.1"
TERMUX_PKG_SRCURL=git+https://github.com/bytecodealliance/wasmtime
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# arm:
# ```
# error: failed to run custom build command for `cranelift-codegen v0.90.1 (/home/builder/.termux-build/wasmtime/src/cranelift/codegen)`
#
# Caused by:
#   process didn't exit successfully: `/home/builder/.termux-build/wasmtime/src/target/release/build/cranelift-codegen-6ca5eab3f38213ac/build-script-build` (exit status: 101)
#   --- stderr
#   thread 'main' panicked at 'error when identifying target: "no supported isa found for arch `armv7`"', cranelift/codegen/build.rs:42:53
# ```
#
# arm, i686:
# ```
# error[E0308]: mismatched types
#   --> /home/builder/.cargo/registry/src/github.com-1ecc6299db9ec823/listenfd-1.0.0/src/unix.rs:14:25
#    |
# 14 |         (stat.st_mode & libc::S_IFMT) == libc::S_IFSOCK
#    |                         ^^^^^^^^^^^^ expected `u32`, found `u16`
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_pkg_auto_update() {
	local e=0
	local api_url="https://api.github.com/repos/bytecodealliance/wasmtime/git/refs/tags"
	local api_url_r=$(curl -s "${api_url}")
	local r1=$(echo "${api_url_r}" | jq .[].ref | sed -ne "s|.*/\(v.*\)\"|\1|p")
	local latest_version=$(echo "${r1}" | sed -nE 's|(^v[0-9]+)|\1|p' | sort -V | tail -n1)
	if [[ "${latest_version}" == "v${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi
	[[ -z "${api_url_r}" ]] && e=1
	[[ -z "${r1}" ]] && e=1
	[[ -z "${latest_version}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		api_url_r=${api_url_r}
		r1=${r1}
		latest_version=${latest_version}
		EOL
		return
	fi

	termux_pkg_upgrade_version "${latest_version/v/}"
}

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/wasmtime"
}
