TERMUX_PKG_HOMEPAGE=https://github.com/foundry-rs/foundry
TERMUX_PKG_DESCRIPTION="A blazing fast, portable and modular toolkit for Ethereum application development"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.3"
TERMUX_PKG_REVISION=1
# The Solidity compilers bundled with the package.
TERMUX_PKG_SOLC_VERSIONS=(
	0.8.28
	0.8.29
	0.8.30
	0.8.31
	0.8.32
	0.8.33
	0.8.34
	0.8.35
	0.8.36
	0.8.37
)
TERMUX_PKG_SOLC_SHA256=(
	ec756e30f26a5a38d028fd6f401ef0a7f5cfbf4a1ce71f76c2e3e1ffb8730672
	fe76237f513b7d6727a93cd5b83f92747650c8dc5f8f89457a41e8f54119ed38
	5e8d58dff551a18205e325c22f1a3b194058efbdc128853afd75d31b0568216d
	1efcf5af92e39499ce64d9cb33ba1cc1aa43d0aba107472915d732bf4a31c837
	b3e0a0def18720b5d11dd454f3de4495f52f719dd059a90b4712ca5efb4cc607
	2fb0a76b13e25b21bcd50607713a563f64709c8c283ed65464db3a2d546b9abf
	415acd0bfc87a12e3c436fb439aabc62639e7a66d433450f0135a23238b4fc7e
	76178a2d5ba92f08b6faa109fdd452a3fbe05ca610a43fa2f1a9426deda7e191
	458c525af3a7bc1b5599e1a125cce960631ab8b3e7110c7ed4c9bbf34157fb86
	705306af6d6e0f4da04b4de7be22a5d7b87a90af0901170e726d8d97b342fcf8
)
TERMUX_PKG_SRCURL=(
	"https://github.com/foundry-rs/foundry/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
)
TERMUX_PKG_SHA256=(
	726c55fac4dfc0ca0062b9c2f6ed5afce66c376e5924f78fcc0e8f623a9a9299
)
for _solc_version in "${TERMUX_PKG_SOLC_VERSIONS[@]}"; do
	TERMUX_PKG_SRCURL+=("https://github.com/argotorg/solidity/releases/download/v${_solc_version}/solidity_${_solc_version}.tar.gz")
done
TERMUX_PKG_SHA256+=("${TERMUX_PKG_SOLC_SHA256[@]}")
unset _solc_version
TERMUX_PKG_DEPENDS="libiconv, ca-certificates, zlib, openssl, libssh2, pcre2, libgit2, boost, libc++"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, fmt, nlohmann-json, range-v3"
TERMUX_PKG_BUILD_IN_SRC=true


build_solc() {
	local version="$1"
	local src_dir="$2"
	local build_dir="$3"
	local output_file="$4"

	local tag
	tag="$(printf '\033[1;36m[solc %s]\033[0m' "$version")"

	# ── 1. Boost components ────────────────────────────────────────────────
	#
	# Solidity asks for `unit_test_framework` (only used by the test suite, which is
	# disabled below) and, before 0.8.31, `system`. Termux's Boost ships neither:
	# Boost.System has been header-only since 1.69, and the unit test framework is not
	# packaged. The `set(BOOST_COMPONENTS ...)` line is what `find_package` consumes,
	# so that is what has to change for this to take effect.

	printf '\n%s patching Boost components\n' "$tag"
	sed -i -E 's/^([[:space:]]*set\(BOOST_COMPONENTS ").*("\))$/\1filesystem;program_options\2/' \
		"$src_dir/cmake/EthDependencies.cmake"

	printf '%s using the Termux fmt instead of the vendored one\n' "$tag"
	sed -i -E '/^[[:space:]]*include\(fmtlib\)[[:space:]]*$/d' "$src_dir/CMakeLists.txt"
	if ! grep -q 'find_package(fmt' "$src_dir/CMakeLists.txt"; then
		sed -i '/^include(EthDependencies)$/a find_package(fmt REQUIRED)' "$src_dir/CMakeLists.txt"
	fi

	# ── 2. libsolutil link line ────────────────────────────────────────────
	# range-v3 and nlohmann-json are header-only
	printf "%s trimming solutil's link libraries\n" "$tag"
	sed -i -E '/^target_link_libraries\(solutil PUBLIC /{ /fmt::fmt-header-only/ s|^.*$|target_link_libraries(solutil PUBLIC Boost::boost Boost::filesystem fmt::fmt-header-only)| }' \
		"$src_dir/libsolutil/CMakeLists.txt"

	# ── 3. boost::process ──────────────────────────────────────────────────
	# Boost 1.91 renamed boost::process to boost::process::v2 and moved the original
	# API to boost::process::v1. Solidity 0.8.28 and 0.8.29 include <boost/process.hpp>
	# (now v2) but use the v1 API, so point them at the v1 header explicitly. Later
	# releases pick v1 themselves when Boost >= 1.88 is detected; that is what the
	# guard below looks for, so only the versions that need the patch get it.

	if grep -qRs 'BOOST_PROCESS_VERSION' "$src_dir/libsolidity/"; then
		printf '%s boost::process v1 handling already provided by this version\n' "$tag"
	else
		printf '%s patching boost::process includes for Boost >= 1.86\n' "$tag"
		local file
		while IFS= read -r file; do
			sed -i 's|^#include <boost/process\.hpp>$|#if __has_include(<boost/process/v1.hpp>)\n#include <boost/process/v1.hpp>\nnamespace boost { namespace process { using namespace v1; } }\n#else\n#include <boost/process.hpp>\n#endif|' \
				"$file"
		done < <(grep -rl '#include <boost/process\.hpp>' --include='*.cpp' --include='*.h' "$src_dir/libsolidity/")
	fi

	# ── 4. Configure ───────────────────────────────────────────────────────
	# Termux's own cmake helper only runs when $TERMUX_PKG_SRCDIR itself contains a
	# CMakeLists.txt, which is not the case for a Rust package that merely carries a
	# few extra C++ source trees. The argument list below therefore mirrors
	# `termux_step_configure_cmake`, with the exception that $LDFLAGS is forwarded
	# through $CMAKE_EXE_LINKER_FLAGS as well: the helper leaves it to the environment
	# and one of its arguments is word-split by accident, so the rpath and hardening
	# flags the build system sets would not reliably reach the linker otherwise.
	#
	# $CFLAGS/$CXXFLAGS/$LDFLAGS are copied before being appended to, so that the
	# `--target` flag does not accumulate across the ten compilers built in turn, and
	# the append happens before the flags are captured into the cmake argument list
	# below -- CMake receives them as a snapshot. `termux_step_configure_cmake` adds
	# the flag at the top of its own function for the same reason.

	local CFLAGS="$CFLAGS"
	local CXXFLAGS="$CXXFLAGS"
	local LDFLAGS="$LDFLAGS"
	local cmake_processor="$TERMUX_ARCH"
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ] && [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		CFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
		CXXFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
		LDFLAGS+=" --target=$CCTERMUX_HOST_PLATFORM"
	fi
	if [ "$cmake_processor" = "arm" ]; then
		cmake_processor="armv7-a"
	fi

	local cmake_args=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_AR="$(command -v "$AR")"
		-DCMAKE_UNAME="$(command -v uname)"
		-DCMAKE_RANLIB="$(command -v "$RANLIB")"
		-DCMAKE_STRIP="$(command -v "$STRIP")"
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS"
		-DCMAKE_CXX_FLAGS="$CXXFLAGS $CPPFLAGS"
		-DCMAKE_EXE_LINKER_FLAGS="$LDFLAGS"
		-DCMAKE_FIND_ROOT_PATH="$TERMUX_PREFIX"
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
		-DCMAKE_INSTALL_PREFIX="$TERMUX_PREFIX"
		-DCMAKE_MAKE_PROGRAM="$(command -v ninja)"
		-DBUILD_TESTING=OFF
		-DIGNORE_VENDORED_DEPENDENCIES=ON
		-DBoost_USE_STATIC_LIBS=OFF
		-DPEDANTIC=OFF
		-DPROFILE_OPTIMIZER_STEPS=OFF
		-DSTRICT_Z3_VERSION=OFF
		-DTESTS=OFF
		-DUSE_CVC4=OFF
		-DUSE_LD_GOLD=OFF
		-DUSE_Z3=OFF
		-DCMAKE_C_COMPILER_LAUNCHER="$(command -v ccache)"
		-DCMAKE_CXX_COMPILER_LAUNCHER="$(command -v ccache)"

	)

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		cmake_args+=("-DCMAKE_LINKER=$(command -v "$LD")")
	else
		cmake_args+=(
			-DCMAKE_LINKER="$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD"
			-DCMAKE_SYSTEM_NAME=Android
			-DCMAKE_SYSTEM_VERSION="$TERMUX_PKG_API_LEVEL"
			-DCMAKE_SYSTEM_PROCESSOR="$cmake_processor"
			-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN="$TERMUX_STANDALONE_TOOLCHAIN"
		)
	fi

	printf '%s configuring\n' "$tag"
	cmake -G Ninja -S "$src_dir" -B "$build_dir" "${cmake_args[@]}"

	# ── 5. Build ───────────────────────────────────────────────────────────

	printf '%s building\n' "$tag"
	ninja -C "$build_dir" -j "${TERMUX_PKG_MAKE_PROCESSES:-$(nproc)}" solc

	# ── 6. Install ─────────────────────────────────────────────────────────
	# The build tree is discarded right away: it is several gigabytes for a single
	# version, and the bundled set is built one after another.

	printf '%s installing to %s\n' "$tag" "$output_file"
	install -Dm755 "$build_dir/solc/solc" "$output_file"
	rm -rf "$build_dir"

	printf '%s checking built compiler\n' "$tag"
	"$output_file" --version ||
		printf '\033[1;33m[solc %s]\033[0m warning: %s could not be executed on this host, skipping version check\n' \
			"$version" "$output_file"
}

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake
	termux_setup_ninja

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		! -wholename ./vendor/aws-lc-sys \
		! -wholename ./vendor/rustls-platform-verifier \
		! -wholename ./vendor/svm-rs \
		! -wholename ./vendor/waitpid-any \
		-exec rm -rf '{}' \;

	local cc_patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	patch -p1 -d vendor/cc < "$cc_patch"

	# Fix getentropy not being available on Android API < 28 (affects 32-bit ARM)
	# patch cc_builder.rs to avoid adding HOST_LDFLAGS
	local aws_patch="$TERMUX_PKG_BUILDER_DIR/aws-lc-sys.diff"
	patch -p1 -d vendor/aws-lc-sys < "$aws_patch"

	local svm_rs_patch="$TERMUX_PKG_BUILDER_DIR/svm-rs-termux.diff"
	patch -p1 -d vendor/svm-rs < "$svm_rs_patch"

	# updated for recent version
	find vendor/rustls-platform-verifier -type f -name "*.rs" -print0 | \
		xargs -0 sed -i \
		-e 's|target_os = "android"|target_os = "disabled_android_apk"|g' \
		-e 's|not(target_os = "android")|not(target_os = "disabled_android_apk")|g' \
		2>/dev/null || true
	# This ensures rustls-native-certs is compiled and available when building in Termux
	if [ -f vendor/rustls-platform-verifier/Cargo.toml ]; then
		# Remove ', not(target_os = "android")' from the Unix block so Termux picks up rustls-native-certs
		sed -i 's|, not(target_os = "android")||g' vendor/rustls-platform-verifier/Cargo.toml

		sed -i 's|cfg(target_os = "android")|cfg(target_os = "disabled_android_apk")|g' vendor/rustls-platform-verifier/Cargo.toml
	fi

	local waitpid_any_patch="$TERMUX_PKG_BUILDER_DIR/waitpid-any-patch.diff"
	patch -p1 -d vendor/waitpid-any < "$waitpid_any_patch"

	sed -i '/\[patch.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a aws-lc-sys = { path = "./vendor/aws-lc-sys" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a waitpid-any = { path = "./vendor/waitpid-any" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a svm-rs = { path = "./vendor/svm-rs" }' Cargo.toml
}

termux_step_make() {
	local solc_root="$TERMUX_PKG_BUILDDIR/.solc"
	local release_list="$TERMUX_PKG_BUILDDIR/foundry-solc-release-list.json"

	# Build the compilers that will be bundled with the package.
	local version src solc_bin checksum first=1
	for version in "${TERMUX_PKG_SOLC_VERSIONS[@]}"; do
		src="$TERMUX_PKG_SRCDIR/solidity_$version"
		solc_bin="$solc_root/solc-$version"
		build_solc "$version" "$src" "$solc_root/build/$version" "$solc_bin"
	done

	# `svm-rs-builds` bakes a release list into the Rust binaries at compile time,
	# and would otherwise fetch the upstream list, which describes binaries that
	# cannot run here. Feed it the list of the versions actually bundled instead, so
	# that its idea of the available compilers matches what is installed.
	#
	# The checksums are those of the binaries as built here; the copies shipped in
	# the package are stripped and elf-cleaned afterwards by the massage step, while
	# nothing on the compiler-selection path verifies a checksum anyway.
	{
		printf '{"builds":['
		for version in "${TERMUX_PKG_SOLC_VERSIONS[@]}"; do
			checksum="$(sha256sum "$solc_root/solc-$version" | cut -d' ' -f1)"
			[ "$first" = 1 ] || printf ','
			first=0
			printf '{"version":"%s","sha256":"0x%s","path":null,"prerelease":null}' \
				"$version" "$checksum"
		done
		printf '],"releases":{'
		first=1
		for version in "${TERMUX_PKG_SOLC_VERSIONS[@]}"; do
			[ "$first" = 1 ] || printf ','
			first=0
			printf '"%s":"solc-%s"' "$version" "$version"
		done
		printf '}}'
	} > "$release_list"
	export SVM_RELEASES_LIST_JSON="$release_list"

	cargo build \
		--bin forge \
		--bin anvil \
		--bin cast \
		--bin chisel \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--no-default-features \
		--features="cli"
}

termux_step_make_install() {
	for binary in forge anvil cast chisel; do
		install -Dm755 \
			"target/${CARGO_TARGET_NAME}/release/$binary" \
			"$TERMUX_PREFIX/bin/$binary"
	done

	# Install the bundled compilers where the patched svm looks for them:
	# $PREFIX/libexec/foundry/svm/<version>/solc-<version>.
	local solc_root="$TERMUX_PKG_BUILDDIR/.solc"
	local svm_dir="$TERMUX_PREFIX/libexec/foundry/svm"
	local version
	mkdir -p "$svm_dir"
	: > "$svm_dir/.global-version"
	for version in "${TERMUX_PKG_SOLC_VERSIONS[@]}"; do
		install -Dm755 "$solc_root/solc-$version" "$svm_dir/$version/solc-$version"
	done
}
