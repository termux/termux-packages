TERMUX_PKG_HOMEPAGE=https://brave.com/
TERMUX_PKG_DESCRIPTION="Privacy-focused web browser based on Chromium"
TERMUX_PKG_LICENSE="MPL-2.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="brave/LICENSE, LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.100.60"
# Must equal the version of chromium-host-tools.
_CHROMIUM_VERSION="158.0.8127.88"
# Dependency pins taken from brave-core's DEPS.
# All pins below, including the ones from EXTRA_DEPS, are rewritten by
# termux_pkg_auto_update() at the end of this file. The update fails if the
# chromium milestone of the new release differs from chromium-host-tools.
_TWEETNACL_COMMIT=8b424ccf29957fe01c88c36076fd32006a357887
_WDP_COMMIT=30044d0f3c3874b7bed05306a1a2243a256310ee
_BIP39_COMMIT=547a7810333d821e29b8f55126aba031aa0d5fcd
_ETHASH_COMMIT=e4a15c3d76dc09392c7efd3e30d84ee3b871e9ce
_BITCOIN_COMMIT=8105bce5b384c72cf08b25b7c5343622754e7337
_ARGON2_COMMIT=62358ba2123abd17fccf2a108a301d4b52c01a7c
_PLAYLIST_COMMIT=673d40f017a1559bb685a15cf608ad1d4a94f8fb
_FUTURES_RETRY_COMMIT=2aaaafbc3d394661534d4dbd14159d164243c20e
_LIBRUSTZCASH_COMMIT=f01f50d64214278552edbe4a34b9049244ce03c1
# Pins taken from brave-core's EXTRA_DEPS.
_BRAVE_NODE_VERSION=26.13.1
_BRAVE_NODE_SHA256=42f574f701489d1d8b647fdbcd4a589dcab1f374dd9c225348b0429f60f76e17
_BRAVE_NODE_MODULES=node_modules-3118333.tar.gz
_BRAVE_NODE_MODULES_SHA256=967a72e63945e75f0249dff1a9836da213020a43305b0030f87946fadcbe292e
_RUST_OVERLAY=linux-x64-rust-toolchain-8a9dd7abdf013ec10cfeaaa3685feba18ef1c90c-1-llvmorg-24-init-14453-ge063be79-1.tar.xz
_RUST_OVERLAY_SHA256=9c09fa3f6a4eddb3cff2061e2c0cc7ccfc8469152656ac2da9a2c4f91a2f6307
_BRAVE_BUCKET=https://brave-build-deps-public.s3.brave.com
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=(
	"https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/${_CHROMIUM_VERSION}/chromium-${_CHROMIUM_VERSION}-linux.tar.xz"
	"https://github.com/brave/brave-core/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	"https://github.com/brave-intl/bat-native-tweetnacl/archive/${_TWEETNACL_COMMIT}.tar.gz"
	"https://github.com/brave/web-discovery-project/archive/${_WDP_COMMIT}.tar.gz"
	"https://github.com/brave-intl/bat-native-bip39wally-core/archive/${_BIP39_COMMIT}.tar.gz"
	"https://github.com/chfast/ethash/archive/${_ETHASH_COMMIT}.tar.gz"
	"https://github.com/bitcoin/bitcoin/archive/${_BITCOIN_COMMIT}.tar.gz"
	"https://github.com/P-H-C/phc-winner-argon2/archive/${_ARGON2_COMMIT}.tar.gz"
	"https://github.com/brave/playlist-component/archive/${_PLAYLIST_COMMIT}.tar.gz"
	"https://github.com/brave-intl/futures-retry/archive/${_FUTURES_RETRY_COMMIT}.tar.gz"
	"https://github.com/brave/librustzcash/archive/${_LIBRUSTZCASH_COMMIT}.tar.gz"
)
TERMUX_PKG_SHA256=(
	603f9ff4a42f7242fdcb2294f98e0ba2eee0486c141c4cc471d82f223d4e5cba
	448e697835ae4cd6eb6dd195a9e4e3d323544992ce6dfb2de31512f7e083bdac
	34cec935dff2e416342a06068bf1c51c9bdced347491b2ab8f6e1557bd2733e6
	da12b2bccdac8213a26f10d647023db53a8ad8613d6d1f3c13ca6347f83dc19f
	66f9022cdeed607b9c920793601dc21878a18da9e13ddce5cea1e204332e7a3c
	98067cedc170cc1621f9eb0e7f3c896aabc0a97abd276c3ee98c5334ca068ae1
	82a28a6c752bccd9eae1778f97217f4166f49b68af93e68d726251fcf3ca54cd
	d177732879114c07a5ab7e6533e61d2c9dff204044335537c89ed16e7d3e4e2f
	25aad361ecb7728ec1b76b6a76b1038b85fbca5bf9da8b076b1cf9e5d5f39183
	a097ca901a4e1beb7067e275d7a8dcfc83202c117b54ce68d8981ecdc7d35501
	2b3ee648fcaf60d4d3043988bb2e87ef95c52c7b144a3ae227cf5d45e0857ad8
)
TERMUX_PKG_DEPENDS="atk, cups, dbus, fontconfig, gtk3, krb5, libc++, libevdev, libxkbcommon, libminizip, libnss, libx11, mesa, openssl, pango, pipewire, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="chromium-host-tools, libffi-static"
# Chromium doesn't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

SYSTEM_LIBRARIES="    fontconfig"

# shellcheck source=x11-packages/brave/helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/helpers.sh"

# Extracted dir name and destination inside brave/ for each pinned dependency.
_BRAVE_DEPS=(
	"bat-native-tweetnacl-${_TWEETNACL_COMMIT}:vendor/bat-native-tweetnacl"
	"web-discovery-project-${_WDP_COMMIT}:vendor/web-discovery-project"
	"bat-native-bip39wally-core-${_BIP39_COMMIT}:third_party/bip39wally-core-native"
	"ethash-${_ETHASH_COMMIT}:third_party/ethash/src"
	"bitcoin-${_BITCOIN_COMMIT}:third_party/bitcoin-core/src"
	"phc-winner-argon2-${_ARGON2_COMMIT}:third_party/argon2/src"
	"playlist-component-${_PLAYLIST_COMMIT}:third_party/playlist_component/src"
	"futures-retry-${_FUTURES_RETRY_COMMIT}:third_party/rust/futures_retry/v0_5/crate"
	"librustzcash-${_LIBRUSTZCASH_COMMIT}:components/brave_wallet/browser/zcash/rust/librustzcash/src"
)

# Apply brave-core patches to chromium and its sub-repos, as brave's own tooling does.
_apply_brave_patches() {
	local patches_dir="$TERMUX_PKG_SRCDIR/brave/patches"
	local p rel repo target
	while read -r p; do
		rel="${p#"$patches_dir"/}"
		repo="$(dirname "$rel")"
		target="$(grep -m1 '^--- ' "$p" | sed -E 's|^--- (a/)?||; s|\t.*||')"
		if [ "$target" != "/dev/null" ] && [ ! -e "$TERMUX_PKG_SRCDIR/$repo/$target" ]; then
			echo "Skipping patch without target: $rel"
			continue
		fi
		(cd "$TERMUX_PKG_SRCDIR/$repo" && patch -p1 -N -l --no-backup-if-mismatch --silent < "$p") ||
			termux_error_exit "Failed to apply brave patch: $rel"
	done < <(find "$patches_dir" -type f -name '*.patch' | sort)
}

# Fetch brave's own node, which also ships the pinned pnpm, and install npm deps.
_setup_brave_npm() {
	local tools="$TERMUX_PKG_CACHEDIR/brave-tools"
	local node_tgz="$TERMUX_PKG_CACHEDIR/node-v${_BRAVE_NODE_VERSION}-linux-x64.tar.gz"
	local mods_tgz="$TERMUX_PKG_CACHEDIR/${_BRAVE_NODE_MODULES}"
	local node_bin pnpm_js

	node_bin="$(find "$tools/node" -maxdepth 3 -type f -path '*/bin/node' 2>/dev/null | head -n 1 || true)"
	if [ -z "$node_bin" ]; then
		termux_download "${_BRAVE_BUCKET}/nodejs/node-v${_BRAVE_NODE_VERSION}-linux-x64.tar.gz" \
			"$node_tgz" "${_BRAVE_NODE_SHA256}"
		rm -rf "$tools/node" && mkdir -p "$tools/node"
		tar -xf "$node_tgz" -C "$tools/node"
		rm -f "$node_tgz"
		node_bin="$(find "$tools/node" -maxdepth 3 -type f -path '*/bin/node' | head -n 1 || true)"
	fi
	[ -n "$node_bin" ] || termux_error_exit "bin/node not found in brave's node tarball."

	pnpm_js="$(find "$tools/node_modules" -maxdepth 6 -type f \( -path '*/pnpm/bin/pnpm.mjs' -o -path '*/pnpm/bin/pnpm.cjs' \) 2>/dev/null | head -n 1 || true)"
	if [ -z "$pnpm_js" ]; then
		termux_download "${_BRAVE_BUCKET}/nodejs/${_BRAVE_NODE_MODULES}" \
			"$mods_tgz" "${_BRAVE_NODE_MODULES_SHA256}"
		rm -rf "$tools/node_modules" && mkdir -p "$tools/node_modules"
		tar -xf "$mods_tgz" -C "$tools/node_modules"
		rm -f "$mods_tgz"
		pnpm_js="$(find "$tools/node_modules" -maxdepth 6 -type f \( -path '*/pnpm/bin/pnpm.mjs' -o -path '*/pnpm/bin/pnpm.cjs' \) | head -n 1 || true)"
	fi
	[ -n "$pnpm_js" ] || termux_error_exit "pnpm.mjs not found in brave's node_modules tarball."

	mkdir -p "$tools/bin"
	printf '#!/bin/sh\nexec "%s" "%s" "$@"\n' "$node_bin" "$pnpm_js" > "$tools/bin/pnpm"
	chmod +x "$tools/bin/pnpm"
	export PATH="$tools/bin:$(dirname "$node_bin"):$PATH"

	if [ ! -d "$TERMUX_PKG_SRCDIR/brave/node_modules" ]; then
		(cd "$TERMUX_PKG_SRCDIR/brave" && pnpm install --frozen-lockfile --yes)
		(cd "$TERMUX_PKG_SRCDIR/brave" && python3 script/web_discovery_project.py --install)
	fi
}

# Overlay brave's rust toolchain files (wasm32 target) on chromium's rust toolchain.
_setup_brave_rust_overlay() {
	local overlay="$TERMUX_PKG_CACHEDIR/${_RUST_OVERLAY}"
	if [ -f "$TERMUX_PKG_SRCDIR/third_party/rust-toolchain/.brave-overlay" ]; then
		return
	fi
	termux_download "${_BRAVE_BUCKET}/rust-toolchain-aux/${_RUST_OVERLAY}" \
		"$overlay" "${_RUST_OVERLAY_SHA256}"
	tar -xf "$overlay" -C "$TERMUX_PKG_SRCDIR/third_party/rust-toolchain"
	touch "$TERMUX_PKG_SRCDIR/third_party/rust-toolchain/.brave-overlay"
	rm -f "$overlay"
}

termux_step_post_get_source() {
	# Version guard
	local version_tools=$(. $TERMUX_SCRIPTDIR/x11-packages/chromium-host-tools/build.sh; echo ${TERMUX_PKG_VERSION})
	if [ "${version_tools}" != "${_CHROMIUM_VERSION}" ]; then
		termux_error_exit "Version mismatch between chromium-host-tools and brave's chromium."
	fi

	# Place brave-core and its pinned dependencies where brave expects them.
	mv "$TERMUX_PKG_SRCDIR/brave-core-${TERMUX_PKG_VERSION}" "$TERMUX_PKG_SRCDIR/brave"
	local entry dir dest
	for entry in "${_BRAVE_DEPS[@]}"; do
		dir="${entry%%:*}"
		dest="$TERMUX_PKG_SRCDIR/brave/${entry#*:}"
		rm -rf "$dest"
		mkdir -p "$(dirname "$dest")"
		mv "$TERMUX_PKG_SRCDIR/$dir" "$dest"
	done

	# The chromium milestone must match what brave-core pins.
	local pinned=$(python3 -c "import json; print(json.load(open('$TERMUX_PKG_SRCDIR/brave/package.json'))['config']['projects']['chrome']['tag'])")
	if [ "${pinned%%.*}" != "${_CHROMIUM_VERSION%%.*}" ]; then
		termux_error_exit "brave-core pins chromium ${pinned}, but ${_CHROMIUM_VERSION} is used."
	fi

	_apply_brave_patches

	# Brave already ships HEVC support, so skip termux's HEVC patches.
	local f
	for f in $(find "$TERMUX_PKG_BUILDER_DIR/../chromium-host-tools/cr-patches" -maxdepth 1 -type f -name *.patch | sort); do
		case "$(basename "$f")" in
			1022-*|2026-*) continue ;;
		esac
		echo "Applying patch: $(basename $f)"
		patch -p1 --silent < "$f"
	done

	# Use some system libs
	python3 build/linux/unbundle/replace_gn_files.py --system-libraries \
		$SYSTEM_LIBRARIES

	# Remove the source files to keep more space
	rm -f "$TERMUX_PKG_CACHEDIR/chromium-${_CHROMIUM_VERSION}-linux.tar.xz"
	rm -f "$TERMUX_PKG_CACHEDIR/v${TERMUX_PKG_VERSION}.tar.gz"
}

termux_step_pre_configure() {
	# Use prebuilt swiftshader
	mv $TERMUX_PKG_SRCDIR/third_party/swiftshader $TERMUX_PKG_SRCDIR/third_party/swiftshader.unused
	mkdir -p $TERMUX_PKG_SRCDIR/third_party/swiftshader/
	cp -Rf $TERMUX_PKG_BUILDER_DIR/third_party_override/swiftshader/* $TERMUX_PKG_SRCDIR/third_party/swiftshader/

	# brave patches chromium's python scripts to import brave_chromium_utils, which
	# brave's own tooling (build/commands/lib/config.ts) makes importable through
	# PYTHONPATH. Mirror that here so gn/ninja python actions can find it.
	local _brave_pythonpath="" _p
	for _p in \
		"$TERMUX_PKG_SRCDIR/brave/script" \
		"$TERMUX_PKG_SRCDIR/tools/grit/grit/extern" \
		"$TERMUX_PKG_SRCDIR/brave/vendor/requests" \
		"$TERMUX_PKG_SRCDIR/build"; do
		_brave_pythonpath+="${_brave_pythonpath:+:}${_p}"
	done
	export PYTHONPATH="${_brave_pythonpath}${PYTHONPATH:+:${PYTHONPATH}}"

	# Write the brave version into chrome/VERSION and generate version.gni
	cd $TERMUX_PKG_SRCDIR
	python3 brave/build/util/version.py update chrome/VERSION --brave-version "$TERMUX_PKG_VERSION"
	python3 brave/build/util/version.py gen chrome/VERSION
}

termux_step_configure() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_ninja
	termux_setup_golang

	# Fetch depot_tools
	export DEPOT_TOOLS_UPDATE=0
	if [ ! -f "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched" ];then
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $TERMUX_PKG_CACHEDIR/depot_tools
		touch "$TERMUX_PKG_CACHEDIR/.depot_tools-fetched"
	fi
	export PATH="$TERMUX_PKG_CACHEDIR/depot_tools:$PATH"
	$TERMUX_PKG_CACHEDIR/depot_tools/ensure_bootstrap

	# Write gpu/webgpu/dawn_commit_hash.h
	if [ ! -f "$TERMUX_PKG_SRCDIR/gpu/webgpu/dawn_commit_hash.h" ]; then
		cat << EOF > $TERMUX_PKG_SRCDIR/gpu/webgpu/dawn_commit_hash.h
/* Generated by lastchange.py, do not edit.*/

#ifndef GPU_WEBGPU_DAWN_COMMIT_HASH_H_
#define GPU_WEBGPU_DAWN_COMMIT_HASH_H_

#define DAWN_COMMIT_HASH "$(cat $TERMUX_PKG_SRCDIR/gpu/webgpu/DAWN_VERSION)"

#endif  // GPU_WEBGPU_DAWN_COMMIT_HASH_H_
EOF
	fi

	# Remove termux's dummy pkg-config
	rm -rf $TERMUX_PKG_CACHEDIR/host-pkg-config-bin
	mkdir -p $TERMUX_PKG_CACHEDIR/host-pkg-config-bin
	ln -s /usr/bin/pkg-config "$TERMUX_PKG_CACHEDIR"/host-pkg-config-bin/pkg-config
	export PATH="$TERMUX_PKG_CACHEDIR/host-pkg-config-bin:$PATH"

	# Install amd64 rootfs
	build/linux/sysroot_scripts/install-sysroot.py --arch=amd64
	local _amd64_sysroot_path="$(pwd)/build/linux/$(ls build/linux | grep 'amd64-sysroot')"

	# Setup rust toolchain and clang toolchain
	./tools/rust/update_rust.py
	./tools/clang/scripts/update.py

	# Brave needs a rust wasm target and npm packages
	_setup_brave_rust_overlay
	_setup_brave_npm

	# Overlay brave's branding, strings and resources onto chromium (needs brave's node_modules)
	__brave_update_branding

	# Link to system tools required by the build
	mkdir -p third_party/jdk/current/bin/
	ln -sf $(command -v java) third_party/jdk/current/bin/
	mkdir -p third_party/dawn/tools/golang/linux-amd64/bin/
	ln -sf $(command -v go) third_party/dawn/tools/golang/linux-amd64/bin/
	mkdir -p third_party/cpython3/host/bin
	ln -sf $(command -v python3) third_party/cpython3/host/bin/

	# Install nodejs
	if [ ! -f "third_party/node/linux/node-linux-x64/bin/node" ]; then
		./third_party/node/update_node_binaries
	fi

	# Download npm deps
	if [ ! -d "third_party/node/node_modules" ]; then
		local _npm_object_name=$(python -c "Var = str
Str = str
exec(open('$TERMUX_PKG_SRCDIR/DEPS').read())
print(deps['src/third_party/node/node_modules']['objects'][0]['object_name'])
")
		local _npm_sha256sum=$(python -c "Var = str
Str = str
exec(open('$TERMUX_PKG_SRCDIR/DEPS').read())
print(deps['src/third_party/node/node_modules']['objects'][0]['sha256sum'])
")
		local _npm_file="$TERMUX_PKG_SRCDIR/third_party/node/node_modules.tar.gz"
		termux_download \
			"https://commondatastorage.googleapis.com/chromium-nodejs/$_npm_object_name" \
			"${_npm_file}" \
			"${_npm_sha256sum}"
		mkdir -p $TERMUX_PKG_SRCDIR/third_party/node/node_modules-tmp
		tar -xf "$_npm_file" --strip-components=1 -C "$TERMUX_PKG_SRCDIR/third_party/node/node_modules-tmp"
		mv "$TERMUX_PKG_SRCDIR/third_party/node/node_modules-tmp" "$TERMUX_PKG_SRCDIR/third_party/node/node_modules"
	fi

	local CARGO_TARGET_NAME="${TERMUX_ARCH}-linux-android"
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		CARGO_TARGET_NAME="armv7-linux-androideabi"
	fi

	# Dummy librt.so
	# Why not dummy a librt.a? Some of the binaries reference symbols only exists in Android
	# for some reason, such as the `chrome_crashpad_handler`, which needs to link with
	# libprotobuf_lite.a, but it is hard to remove the usage of `android/log.h` in protobuf.
	echo "INPUT(-llog -liconv -landroid-shmem)" > "$TERMUX_PREFIX/lib/librt.so"

	# Dummy libpthread.a and libresolv.a
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libpthread.a"
	echo '!<arch>' > "$TERMUX_PREFIX/lib/libresolv.a"

	# Symlink libffi.a to libffi_pic.a
	ln -sfr $TERMUX_PREFIX/lib/libffi.a $TERMUX_PREFIX/lib/libffi_pic.a

	# Merge sysroots
	if [ ! -d "$TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH" ]; then
		rm -rf $TERMUX_PKG_TMPDIR/sysroot
		mkdir -p $TERMUX_PKG_TMPDIR/sysroot
		pushd $TERMUX_PKG_TMPDIR/sysroot
		mkdir -p usr/include usr/lib usr/bin
		cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/* usr/include
		cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/$TERMUX_HOST_PLATFORM/* usr/include
		cp -R $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/* usr/lib/
		cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_shared.so" usr/lib/
		cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++_static.a" usr/lib/
		cp "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/libc++abi.a" usr/lib/
		cp -Rf $TERMUX_PREFIX/include/* usr/include
		cp -Rf $TERMUX_PREFIX/lib/* usr/lib
		ln -sf /data ./data
		# This is needed to build cups
		cp -Rf $TERMUX_PREFIX/bin/cups-config usr/bin/
		chmod +x usr/bin/cups-config
		# Temporarily disable check
		# Will be enabled after investigating how to correctly append android build target flags to `bindgen`
		patch -p1 < $TERMUX_PKG_BUILDER_DIR/9999-sysroot-disable-target-check.diff
		popd
		mv $TERMUX_PKG_TMPDIR/sysroot $TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH
	fi

	# Construct args
	local _clang_base_path="$PWD/third_party/llvm-build/Release+Asserts"
	local _host_cc="$_clang_base_path/bin/clang"
	local _host_cxx="$_clang_base_path/bin/clang++"
	local _host_clang_version=$($_host_cc --version | grep -m1 version | sed -E 's|.*\bclang version ([0-9]+).*|\1|')
	local _target_clang_base_path="$TERMUX_STANDALONE_TOOLCHAIN"
	local _target_cc="$_target_clang_base_path/bin/clang"
	local _target_clang_version=$($_target_cc --version | grep -m1 version | sed -E 's|.*\bclang version ([0-9]+).*|\1|')
	local _target_cpu _target_sysroot="$TERMUX_PKG_CACHEDIR/sysroot-$TERMUX_ARCH"
	local _v8_toolchain_name _v8_current_cpu _v8_sysroot_path
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		_target_cpu="arm64"
		_v8_current_cpu="arm64"
		_v8_sysroot_path="$_amd64_sysroot_path"
		_v8_toolchain_name="host"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		# Install i386 rootfs
		build/linux/sysroot_scripts/install-sysroot.py --arch=i386
		local _i386_sysroot_path="$(pwd)/build/linux/$(ls build/linux | grep 'i386-sysroot')"
		_target_cpu="arm"
		_v8_current_cpu="x86"
		_v8_sysroot_path="$_i386_sysroot_path"
		_v8_toolchain_name="clang_x86_v8_arm"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		_target_cpu="x64"
		_v8_current_cpu="x64"
		_v8_sysroot_path="$_amd64_sysroot_path"
		_v8_toolchain_name="host"
	fi

	local _common_args_file=$TERMUX_PKG_TMPDIR/common-args-file
	cp $TERMUX_PKG_BUILDER_DIR/brave-args.gn $_common_args_file

	sed -e "s|@HOST_CLANG_VERSION@|$_host_clang_version|g" \
		-e "s|@TARGET_CPU@|$_target_cpu|g" \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TARGET_SYSROOT@|$_target_sysroot|g" \
		-e "s|@TARGET_CLANG_BASE_PATH@|$_target_clang_base_path|g" \
		-e "s|@TARGET_CLANG_VERSION@|$_target_clang_version|g" \
		-e "s|@TERMUX_PKG_CACHEDIR@|$TERMUX_PKG_CACHEDIR|g" \
		-e "s|@V8_TOOLCHAIN_NAME@|$_v8_toolchain_name|g" \
		-e "s|@CARGO_TARGET_NAME@|$CARGO_TARGET_NAME|g" \
		$TERMUX_PKG_BUILDER_DIR/common-args.gn.in >> $_common_args_file

	# brave overrides some chromium .cc files through //brave/chromium_src, which its
	# own build only applies via siso. Do the same with a compiler wrapper.
	sed "s|@SRCDIR@|$(realpath -ms "$TERMUX_PKG_SRCDIR")|g" \
		$TERMUX_PKG_BUILDER_DIR/redirect-cc.sh.in > $TERMUX_PKG_CACHEDIR/redirect-cc.sh
	chmod +x $TERMUX_PKG_CACHEDIR/redirect-cc.sh
	echo "cc_wrapper = \"$TERMUX_PKG_CACHEDIR/redirect-cc.sh\"" >> $_common_args_file

	if [ "$TERMUX_ARCH" = "arm" ]; then
		echo "arm_arch = \"armv7-a\"" >> $_common_args_file
		echo "arm_float_abi = \"softfp\"" >> $_common_args_file
	fi

	# Use custom toolchain
	rm -rf $TERMUX_PKG_CACHEDIR/custom-toolchain
	mkdir -p $TERMUX_PKG_CACHEDIR/custom-toolchain
	cp -f $TERMUX_PKG_BUILDER_DIR/toolchain-template/host-toolchain.gn.in $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	sed -i "s|@HOST_CC@|$_host_cc|g
			s|@HOST_CXX@|$_host_cxx|g
			s|@HOST_LD@|$_host_cxx|g
			s|@HOST_AR@|$(command -v llvm-ar)|g
			s|@HOST_NM@|$(command -v llvm-nm)|g
			s|@HOST_IS_CLANG@|true|g
			s|@HOST_SYSROOT@|$_amd64_sysroot_path|g
			s|@V8_CURRENT_CPU@|$_target_cpu|g
			" $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	if [ "$_v8_toolchain_name" != "host" ]; then
		cat $TERMUX_PKG_BUILDER_DIR/toolchain-template/v8-toolchain.gn.in >> $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
		sed -i "s|@V8_CC@|$_host_cc|g
				s|@V8_CXX@|$_host_cxx|g
				s|@V8_LD@|$_host_cxx|g
				s|@V8_AR@|$(command -v llvm-ar)|g
				s|@V8_NM@|$(command -v llvm-nm)|g
				s|@V8_TOOLCHAIN_NAME@|$_v8_toolchain_name|g
				s|@V8_CURRENT_CPU@|$_v8_current_cpu|g
				s|@V8_V8_CURRENT_CPU@|$_target_cpu|g
				s|@V8_IS_CLANG@|true|g
				s|@V8_SYSROOT@|$_v8_sysroot_path|g
				" $TERMUX_PKG_CACHEDIR/custom-toolchain/BUILD.gn
	fi

	# Generate ninja files
	mkdir -p $TERMUX_PKG_BUILDDIR/out/Release
	cat $_common_args_file > $TERMUX_PKG_BUILDDIR/out/Release/args.gn
	gn gen $TERMUX_PKG_BUILDDIR/out/Release
}

termux_step_make() {
	cd $TERMUX_PKG_BUILDDIR

	# depot_tools' ninja wrapper looks for the checkout above the out dir to resolve
	# the "//brave/..." imports of args.gn, but the out dir is outside the source tree.
	# Put the real ninja ahead of depot_tools in PATH.
	termux_setup_ninja

	# Build v8 snapshot in another action
	ninja -C out/Release \
		v8_context_snapshot \
		run_mksnapshot_default \
		run_torque \
		generate_bytecode_builtins_list \
		v8:run_gen-regexp-special-case

	# Build generate steps in another action
	ninja -C out/Release \
		generate_top_domain_list_variables_file \
		generate_chrome_colors_info \
		character_data \
		gen_root_store_inc \
		generate_transport_security_state \
		generate_transport_security_state_pins \
		generate_top_domains_trie

	# Build swiftshader in another action
	ninja -C out/Release \
		third_party/swiftshader/src/Vulkan:icd_file \
		third_party/swiftshader/src/Vulkan:swiftshader_libvulkan

	# Build pdfium in another action
	ninja -C out/Release \
		third_party/pdfium \
		third_party/pdfium:pdfium_public_headers

	# Build brave's resources, then the browser
	ninja -C out/Release brave:packed_resources
	ninja -C out/Release chrome chrome_crashpad_handler
}

termux_step_make_install() {
	cd $TERMUX_PKG_BUILDDIR
	mkdir -p $TERMUX_PREFIX/lib/brave

	local normal_files=(
		chrome_crashpad_handler
		icudtl.dat
		snapshot_blob.bin
		v8_context_snapshot.bin
		libEGL.so
		libGLESv2.so
		libvulkan.so.1
		libVkICD_mock_icd.so
		libvk_swiftshader.so
		vk_swiftshader_icd.json
		libffmpeg.so
	)
	cp "${normal_files[@]/#/out/Release/}" "$TERMUX_PREFIX/lib/brave/"
	cp out/Release/*.pak "$TERMUX_PREFIX/lib/brave/"

	# The browser binary is named brave
	install -Dm755 out/Release/chrome "$TERMUX_PREFIX/lib/brave/brave"

	cp -Rf out/Release/angledata $TERMUX_PREFIX/lib/brave/
	cp -Rf out/Release/locales $TERMUX_PREFIX/lib/brave/
	cp -Rf out/Release/MEIPreload $TERMUX_PREFIX/lib/brave/
	cp -Rf out/Release/resources $TERMUX_PREFIX/lib/brave/

	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		$TERMUX_PKG_BUILDER_DIR/brave-launcher.sh.in > $TERMUX_PREFIX/lib/brave/brave-launcher.sh
	chmod +x $TERMUX_PREFIX/lib/brave/brave-launcher.sh
	ln -sfr $TERMUX_PREFIX/lib/brave/brave-launcher.sh $TERMUX_PREFIX/bin/brave-browser

	# Desktop entry from chromium's template
	install -Dm644 $TERMUX_PKG_SRCDIR/chrome/installer/linux/common/desktop.template \
		"$TERMUX_PREFIX/share/applications/brave-browser.desktop"
	sed -i \
		-e 's/@@MENUNAME/Brave/g' \
		-e 's/@@PACKAGE/brave-browser/g' \
		-e 's/@@usr_bin_symlink_name/brave-browser/g' \
		-e 's|@@uri_scheme||g' \
		-e 's/@@extra_desktop_entries//g' \
		-e "s|@@desktop_exec|$TERMUX_PREFIX/bin/brave-browser|g" \
		-e 's|@@startup_wm_class|Brave-browser|g' \
		-e 's|@@desktop_icon|brave-browser|g' \
		-e "s|Exec=/usr/bin|Exec=$TERMUX_PREFIX/bin|g" \
		"$TERMUX_PREFIX/share/applications/brave-browser.desktop"

	# Icons from brave's own branding
	local size
	for size in 24 48 64 128 256; do
		install -Dm644 "$TERMUX_PKG_SRCDIR/brave/app/theme/brave/linux/product_logo_$size.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${size}x${size}/apps/brave-browser.png"
	done
	for size in 16 32; do
		install -Dm644 "$TERMUX_PKG_SRCDIR/brave/app/theme/default_100_percent/brave/linux/product_logo_$size.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${size}x${size}/apps/brave-browser.png"
	done
}

termux_step_post_make_install() {
	# Remove the dummy files
	rm $TERMUX_PREFIX/lib/lib{{pthread,resolv,ffi_pic}.a,rt.so}
}

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(__brave_get_latest_version)"
	[[ "${latest_version}" =~ ^v?[0-9]+(\.[0-9]+){2}$ ]] ||
		termux_error_exit "Unexpected brave tag '${latest_version}'"
	latest_version="${latest_version#v}"

	# Only rewrite the pins when an update will really happen.
	if termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${latest_version}" &&
		[[ "${BUILD_PACKAGES}" != "false" && -z "${TERMUX_PKG_UPGRADE_VERSION_DRY_RUN:-}" ]]; then
		__brave_resolve_source_pins "${latest_version}"

		local entry var new
		local -a sed_args=()
		for entry in "${__BRAVE_DEPS_PINS[@]}"; do
			var="${entry%%:*}"
			new="_NEW${var}"
			sed_args+=(-e "s/^\(${var}=\).*/\1${!new}/")
		done
		for var in _BRAVE_NODE_VERSION _BRAVE_NODE_SHA256 _BRAVE_NODE_MODULES \
			_BRAVE_NODE_MODULES_SHA256 _RUST_OVERLAY _RUST_OVERLAY_SHA256; do
			new="_NEW${var}"
			sed_args+=(-e "s/^\(${var}=\).*/\1${!new}/")
		done
		sed "${sed_args[@]}" -i "${TERMUX_PKG_BUILDER_DIR}/build.sh"
	fi

	termux_pkg_upgrade_version "${latest_version}"
}
