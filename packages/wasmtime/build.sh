TERMUX_PKG_HOMEPAGE=https://wasmtime.dev/
TERMUX_PKG_DESCRIPTION="A standalone runtime for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="39.0.0"
TERMUX_PKG_SRCURL=git+https://github.com/bytecodealliance/wasmtime
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

#   = note: ld.lld: error: relocation R_386_32 cannot be used against local symbol;
# recompile with -fPIC
#           >>> defined in /home/builder/.termux-build/wasmtime/src/target/
# i686-linux-android/release/deps/libwasmtime_internal_fiber-ed766d87e782b761.rlib
# (wasmtime_internal_fiber-ed766d87e782b761.wasmtime_internal_fiber.32287cf82a9b7e1f-cgu.
# 0.rcgu.o)
#           >>> referenced by wasmtime_internal_fiber.32287cf82a9b7e1f-cgu.0
#           >>>               wasmtime_internal_fiber-ed766d87e782b761.
# wasmtime_internal_fiber.32287cf82a9b7e1f-cgu.0.rcgu.o:(wasmtime_internal_fiber::
# stackswitch::x86::wasmtime_fiber_init::hd48a3380a323ed84) in archive
# /home/builder/.termux-build/wasmtime/src/target/i686-linux-android/
# release/deps/libwasmtime_internal_fiber-ed766d87e782b761.rlib
#           clang: error: linker command failed with exit code 1
# (use -v to see invocation)
TERMUX_PKG_EXCLUDED_ARCHES="i686"

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

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/listenfd \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/listenfd-32-bit-android.diff"
	local dir="vendor/listenfd"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "${patch}"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'listenfd = { path = "./vendor/listenfd" }' >> Cargo.toml
}

termux_step_make() {
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/wasmtime"
}
