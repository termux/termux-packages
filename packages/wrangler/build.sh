TERMUX_PKG_HOMEPAGE=https://developers.cloudflare.com/workers/wrangler/
TERMUX_PKG_DESCRIPTION="Cloudflare Workers command-line tooling with native Android workerd and esbuild"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_MAINTAINER="@adybag14-cyber"
TERMUX_PKG_VERSION="4.123.0"
_WORKERD_VERSION="1.20260811.1"
_PNPM_VERSION="10.33.0"
_BAZEL_VERSION="9.2.0"
_ESBUILD_VERSIONS=(
	0.18.20
	0.23.1
	0.24.2
	0.27.3
	0.28.1
)
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT, workerd-${_WORKERD_VERSION}/LICENSE, esbuild-${_ESBUILD_VERSIONS[-1]}/LICENSE.md"
TERMUX_PKG_SRCURL=(
	"https://github.com/cloudflare/workers-sdk/archive/refs/tags/wrangler%40${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/cloudflare/workerd/archive/refs/tags/v${_WORKERD_VERSION}.tar.gz"
	"https://github.com/evanw/esbuild/archive/refs/tags/v${_ESBUILD_VERSIONS[0]}.tar.gz"
	"https://github.com/evanw/esbuild/archive/refs/tags/v${_ESBUILD_VERSIONS[1]}.tar.gz"
	"https://github.com/evanw/esbuild/archive/refs/tags/v${_ESBUILD_VERSIONS[2]}.tar.gz"
	"https://github.com/evanw/esbuild/archive/refs/tags/v${_ESBUILD_VERSIONS[3]}.tar.gz"
	"https://github.com/evanw/esbuild/archive/refs/tags/v${_ESBUILD_VERSIONS[4]}.tar.gz"
	"https://registry.npmjs.org/pnpm/-/pnpm-${_PNPM_VERSION}.tgz"
)
TERMUX_PKG_SHA256=(
	7251a6784a8427e0b79fd849de0445af24bade1930a88afc172ac40abf37eaff
	bad369875859db11ae72cf2ce8e221345072a1b580d58e6849fadd0ee6b66836
	f4072282dd01d9343b03e6551f88599d9877b5e9f3a82e595e988e091249a86f
	da504f77d1856e642de6d6e96bab7ddc1da9a73726c7a67467eb4c2b7c0fdaae
	171e1b0cd4c64222a1953203f6b3dab3c7a3f95b8939a72b4ebbd024302513b4
	05d56070104b46d24c8921bfc4c83209d71cf583eb0396c13d0f359705bb5b61
	65c756fa87d43178ac4a5242454c2bd0fde325f8ecf77997f8fa4b88f94d5cd2
	bfcc1bcbad279b13a516c446a75b3c58b6904b45d57a1951411015e50b751a80
)
TERMUX_PKG_DEPENDS="libc++, nodejs | nodejs-lts"
# termux_setup_proot executes cross-built Android generator tools during the
# workerd/V8 build and requires the package-builder's Bionic userspace.
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_BUILD_IN_SRC=true
# workerd's Bazel zlib port explicitly supports only x86_64 and arm64, and
# its pinned Rust toolchains likewise target 64-bit hosts. Support both Termux
# 64-bit architectures while leaving the unsupported 32-bit targets excluded.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
# workerd and esbuild versions are coupled to each Wrangler release. Keep
# updates deliberate until an update hook can validate that tuple.
TERMUX_PKG_AUTO_UPDATE=false

_wrangler_set_arch() {
	case "$TERMUX_ARCH" in
		aarch64)
			_WRANGLER_GOARCH=arm64
			_WRANGLER_WORKERD_PLATFORM=android_arm64
			_WRANGLER_V8_CPU=arm64
			_WRANGLER_ELF_MACHINE=AArch64
			;;
		x86_64)
			_WRANGLER_GOARCH=amd64
			_WRANGLER_WORKERD_PLATFORM=android_x86_64
			_WRANGLER_V8_CPU=x64
			_WRANGLER_ELF_MACHINE='Advanced Micro Devices X86-64'
			;;
		*)
			termux_error_exit "Unsupported Wrangler architecture: $TERMUX_ARCH"
			;;
	esac
}

termux_step_post_get_source() {
	local expected_workerd
	expected_workerd="$(sed -n 's/^  workerd: "\([^"]*\)"/\1/p' pnpm-workspace.yaml | head -n1)"
	local expected_esbuild
	expected_esbuild="$(sed -n 's/^  esbuild: "\([^"]*\)"/\1/p' pnpm-workspace.yaml | head -n1)"
	local expected_pnpm
	expected_pnpm="$(python3 -c 'import json; print(json.load(open("package.json"))["packageManager"].removeprefix("pnpm@"))')"

	[[ "$expected_workerd" == "$_WORKERD_VERSION" ]] || \
		termux_error_exit "Wrangler $TERMUX_PKG_VERSION expects workerd $expected_workerd, recipe pins $_WORKERD_VERSION"
	[[ "$expected_esbuild" == "${_ESBUILD_VERSIONS[-1]}" ]] || \
		termux_error_exit "Wrangler $TERMUX_PKG_VERSION expects esbuild $expected_esbuild, recipe pins ${_ESBUILD_VERSIONS[-1]}"
	[[ "$expected_pnpm" == "$_PNPM_VERSION" ]] || \
		termux_error_exit "Wrangler $TERMUX_PKG_VERSION expects pnpm $expected_pnpm, recipe pins $_PNPM_VERSION"

	[[ -d "workerd-${_WORKERD_VERSION}" ]] || termux_error_exit "workerd source archive was not extracted"
	for version in "${_ESBUILD_VERSIONS[@]}"; do
		[[ -d "esbuild-$version" ]] || termux_error_exit "esbuild $version source archive was not extracted"
	done

	# The npm tarball has a generic top-level `package/` directory. Give it a
	# stable package-local name and verify the exact version before use.
	[[ -d package ]] || termux_error_exit "pnpm source archive was not extracted"
	mv package "pnpm-${_PNPM_VERSION}"
	local pnpm_archive_version
	pnpm_archive_version="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "pnpm-${_PNPM_VERSION}/package.json")"
	[[ "$pnpm_archive_version" == "$_PNPM_VERSION" ]] || termux_error_exit "Unexpected pnpm source version: $pnpm_archive_version"

}

termux_step_pre_configure() {
	_wrangler_set_arch
	termux_setup_nodejs
	termux_setup_golang
	termux_setup_proot

	# workerd is a secondary source archive, so apply its Android/Bionic port
	# explicitly. Keep the API level symbolic in the checked-in diff and bind
	# it to the package build's selected Android API level here.
	local workerd_tree="$TERMUX_PKG_SRCDIR/workerd-${_WORKERD_VERSION}"
	local workerd_diff="$TERMUX_PKG_BUILDER_DIR/patches/workerd-android.diff"
	echo "Applying patch: $(basename "$workerd_diff")"
	sed "s|@TERMUX_PKG_API_LEVEL@|$TERMUX_PKG_API_LEVEL|g" "$workerd_diff" | \
		patch --silent -d "$workerd_tree" -p1

	mkdir -p "$TERMUX_PKG_TMPDIR/bin"
	local pnpm_js="$TERMUX_PKG_SRCDIR/pnpm-${_PNPM_VERSION}/bin/pnpm.cjs"
	[[ -f "$pnpm_js" ]] || termux_error_exit "Pinned pnpm entrypoint is missing"
	cat > "$TERMUX_PKG_TMPDIR/bin/pnpm" <<-EOF
		#!/bin/sh
		exec node "$pnpm_js" "\$@"
	EOF
	chmod 0700 "$TERMUX_PKG_TMPDIR/bin/pnpm"
	export PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
	[[ "$(pnpm --version)" == "$_PNPM_VERSION" ]] || termux_error_exit "Unexpected pnpm version"

	local workerd_bazel_version
	workerd_bazel_version="$(tr -d '[:space:]' < "$workerd_tree/.bazelversion")"
	[[ "$workerd_bazel_version" == "$_BAZEL_VERSION" ]] || \
		termux_error_exit "workerd expects Bazel $workerd_bazel_version, recipe pins $_BAZEL_VERSION"
	local bazel_bin="$TERMUX_PKG_TMPDIR/bin/bazel"
	termux_download \
		"https://github.com/bazelbuild/bazel/releases/download/${_BAZEL_VERSION}/bazel-${_BAZEL_VERSION}-linux-x86_64" \
		"$bazel_bin" \
		7668a95db1250f12c40407251e4e203b4ec8bf39bc495d2f485b2d8c99048694
	chmod 0700 "$bazel_bin"
	[[ "$($bazel_bin --version)" == "bazel $_BAZEL_VERSION" ]] || termux_error_exit "Unexpected Bazel version"

	local proot_runner
	proot_runner="$(command -v termux-proot-run)"
	[[ -x "$proot_runner" ]] || termux_error_exit "termux-proot-run is unavailable after termux_setup_proot"

	local target_runner="$TERMUX_PKG_TMPDIR/workerd-android-run-under"
	cat > "$target_runner" <<-EOF
		#!/bin/bash
		# Bazel actions run with a hermetic PATH that excludes Termux's cached
		# proot helper directory, so embed the resolved helper path here.
		exec "$proot_runner" env LD_PRELOAD= LD_LIBRARY_PATH= "\$@"
	EOF
	chmod 0700 "$target_runner"

	# Static Android source changes live in patches/workerd-android.diff. Only
	# builder-local absolute paths belong here.
	cat >> "$workerd_tree/.bazelrc" <<-EOF

# Native Android configuration for the official Termux package build.
build:android --config=unix
build:android --@capnp-cpp//src/kj:libdl=False
build:android --repo_env=CC=$TERMUX_HOST_LLVM_BASE_DIR/bin/clang
build:android --repo_env=AR=$TERMUX_HOST_LLVM_BASE_DIR/bin/llvm-ar
build:android --host_linkopt=--ld-path=$TERMUX_HOST_LLVM_BASE_DIR/bin/ld.lld
build:android --host_linkopt=-latomic
build:android --//build/config:target_run_under=$target_runner
build:android --@v8//bazel/config:v8_target_cpu=$_WRANGLER_V8_CPU
build:release_android --config=android
build:release_android --config=release_unix
build:release_android --@workerd//src/workerd/server:use_tcmalloc=False
build:release_android --@workerd//src/workerd/util:use_perfetto=False
	EOF

	export ANDROID_NDK_HOME="$NDK"
}

_build_esbuild() {
	local version="$1"
	local goos="$2"
	local goarch="$3"
	local output="$4"
	(
		cd "$TERMUX_PKG_SRCDIR/esbuild-$version"
		CGO_ENABLED=0 GOOS="$goos" GOARCH="$goarch" \
			go build -trimpath -o "$output" ./cmd/esbuild
	)
	chmod 0700 "$output"
}

termux_step_make() {
	_wrangler_set_arch
	export NODE_ENV=production
	export CI_OS=Linux
	export WRANGLER_SEND_METRICS=false
	export PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"

	# Build every host esbuild version used by Wrangler's filtered dependency
	# graph from source, then replace npm's platform payloads before any build
	# script can execute them.
	pnpm --filter="wrangler..." install --frozen-lockfile --ignore-scripts
	for version in "${_ESBUILD_VERSIONS[@]}"; do
		local host_binary="$TERMUX_PKG_TMPDIR/esbuild-host-$version"
		_build_esbuild "$version" linux amd64 "$host_binary"
		[[ "$($host_binary --version)" == "$version" ]] || termux_error_exit "Host esbuild $version verification failed"

		mapfile -t targets < <(
			find node_modules/.pnpm \
				-path "*/@esbuild+linux-x64@$version/node_modules/@esbuild/linux-x64/bin/esbuild" \
				-type f
		)
		((${#targets[@]} > 0)) || termux_error_exit "No installed @esbuild/linux-x64 payload for $version"
		for target in "${targets[@]}"; do
			install -m 0700 "$host_binary" "$target"
		done
	done

	local target_esbuild="$TERMUX_PKG_TMPDIR/esbuild-android"
	if [[ "$TERMUX_ARCH" == x86_64 ]]; then
		# Go requires external linking for android/amd64. Use Termux's NDK
		# target compiler; esbuild itself remains built entirely from source.
		(
			cd "$TERMUX_PKG_SRCDIR/esbuild-${_ESBUILD_VERSIONS[-1]}"
			CGO_ENABLED=1 GOOS=android GOARCH="$_WRANGLER_GOARCH" CC="$CC" \
				go build -trimpath -o "$target_esbuild" ./cmd/esbuild
		)
		chmod 0700 "$target_esbuild"
	else
		_build_esbuild "${_ESBUILD_VERSIONS[-1]}" android "$_WRANGLER_GOARCH" "$target_esbuild"
	fi

	pnpm --filter="wrangler..." build
	local deploy="$TERMUX_PKG_TMPDIR/wrangler-deploy"
	rm -rf "$deploy"
	pnpm --filter=wrangler deploy "$deploy" --prod --legacy --no-optional --ignore-scripts

	local workerd_tree="$TERMUX_PKG_SRCDIR/workerd-${_WORKERD_VERSION}"
	(
		cd "$workerd_tree"
		ANDROID_NDK_HOME="$NDK" "$TERMUX_PKG_TMPDIR/bin/bazel" build \
			//src/workerd/server:workerd \
			--enable_platform_specific_config=false \
			--config=release_android \
			--platforms=//:$_WRANGLER_WORKERD_PLATFORM \
			--jobs="$TERMUX_PKG_MAKE_PROCESSES" \
			--verbose_failures
	)

	local workerd_binary="$workerd_tree/bazel-bin/src/workerd/server/workerd"
	[[ -x "$workerd_binary" ]] || termux_error_exit "workerd Android binary was not produced"
}

termux_step_make_install() {
	_wrangler_set_arch
	local deploy="$TERMUX_PKG_TMPDIR/wrangler-deploy"
	local target_esbuild="$TERMUX_PKG_TMPDIR/esbuild-android"
	local workerd_binary="$TERMUX_PKG_SRCDIR/workerd-${_WORKERD_VERSION}/bazel-bin/src/workerd/server/workerd"

	python3 "$TERMUX_PKG_BUILDER_DIR/prepare-wrangler-deploy.py" \
		--deploy "$deploy" \
		--prefix "$TERMUX_PREFIX" \
		--workerd-binary "$workerd_binary" \
		--esbuild-binary "$target_esbuild" \
		--wrangler-version "$TERMUX_PKG_VERSION"
}

termux_step_post_make_install() {
	_wrangler_set_arch
	local workerd_binary="$TERMUX_PREFIX/lib/wrangler/native/workerd"
	local esbuild_binary="$TERMUX_PREFIX/lib/wrangler/native/esbuild"
	for binary in "$workerd_binary" "$esbuild_binary"; do
		[[ -x "$binary" ]] || termux_error_exit "Missing native runtime: $binary"
		readelf -h "$binary" | grep -Fq "$_WRANGLER_ELF_MACHINE" || \
			termux_error_exit "Wrong-architecture native runtime for $TERMUX_ARCH: $binary"
		readelf -l "$binary" | grep -Fq '/system/bin/linker64' || \
			termux_error_exit "Non-Android ELF interpreter: $binary"
		if readelf -d "$binary" 2>/dev/null | grep -Fq 'libc.so.6'; then
			termux_error_exit "glibc dependency detected: $binary"
		fi
	done
}
