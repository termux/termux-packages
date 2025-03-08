# shellcheck shell=bash
# This provides an utility function to setup iserv (external interpreter of ghc) to cross compile haskell-template.

__termux_setup_proot() {
	local TERMUX_PROOT_VERSION=5.3.0
	local TERMUX_QEMU_VERSION=7.2.0-1
	local TERMUX_PROOT_BIN="$TERMUX_COMMON_CACHEDIR/proot-bin"
	local TERMUX_PROOT_QEMU=""
	local TERMUX_PROOT_BIN_NAME="termux-proot-run-$TERMUX_ARCH"

	export PATH="$TERMUX_PROOT_BIN:$PATH"

	[[ -f "$TERMUX_PROOT_BIN/$TERMUX_PROOT_BIN_NAME" ]] && return

	if ! [[ -d "$TERMUX_PREFIX/opt/aosp" ]]; then
		echo "ERROR: Add 'aosp-libs' to TERMUX_PKG_BUILD_DEPENDS. 'proot' cannot run without it."
		exit 1
	fi

	mkdir -p "$TERMUX_PROOT_BIN"

	termux_download https://github.com/proot-me/proot/releases/download/v"$TERMUX_PROOT_VERSION"/proot-v"$TERMUX_PROOT_VERSION"-x86_64-static \
		"$TERMUX_PROOT_BIN/proot" \
		d1eb20cb201e6df08d707023efb000623ff7c10d6574839d7bb42d0adba6b4da
	chmod +x "$TERMUX_PROOT_BIN"/proot

	declare -A checksums=(
		["aarch64"]="dce64b2dc6b005485c7aa735a7ea39cb0006bf7e5badc28b324b2cd0c73d883f"
		["arm"]="9f07762a3cd0f8a199cb5471a92402a4765f8e2fcb7fe91a87ee75da9616a806"
	)
	if [[ "$TERMUX_ARCH" == "aarch64" ]] || [[ "$TERMUX_ARCH" == "arm" ]]; then
		termux_download https://github.com/multiarch/qemu-user-static/releases/download/v"$TERMUX_QEMU_VERSION"/qemu-"$TERMUX_ARCH"-static \
			"$TERMUX_PROOT_BIN"/qemu-"$TERMUX_ARCH" \
			"${checksums[$TERMUX_ARCH]}"
		chmod +x "$TERMUX_PROOT_BIN"/qemu-"$TERMUX_ARCH"
		TERMUX_PROOT_QEMU="-q $TERMUX_PROOT_BIN/qemu-$TERMUX_ARCH"
	fi

	# NOTE: We include current PATH too so that host binaries are also become available under proot.
	cat <<-EOF >"$TERMUX_PROOT_BIN/$TERMUX_PROOT_BIN_NAME"
		#!/bin/bash
		env -i \
			PATH=$TERMUX_PREFIX/bin:$PATH \
			ANDROID_DATA=/data \
			ANDROID_ROOT=/system \
			HOME=$TERMUX_ANDROID_HOME \
			LANG=en_US.UTF-8 \
			PREFIX=$TERMUX_PREFIX \
			TERM=$TERM \
			TZ=UTC \
			$TERMUX_PROOT_BIN/proot \
			$TERMUX_PROOT_QEMU \
			-R / \
			"\$@"
	EOF
	chmod +x "$TERMUX_PROOT_BIN/$TERMUX_PROOT_BIN_NAME"
}

termux_setup_ghc_iserv() {
	local TERMUX_ISERV_VERSION=9.12.1
	local TERMUX_ISERV_TAR="$TERMUX_COMMON_CACHEDIR/iserv-$TERMUX_ISERV_VERSION.tar"
	local TERMUX_ISERV_BIN="$TERMUX_COMMON_CACHEDIR/iserv-bin"
	local TERMUX_ISERV_BIN_NAME="ghc-iserv-$TERMUX_ARCH"

	__termux_setup_proot
	export PATH="$TERMUX_ISERV_BIN:$PATH"

	[[ -f "$TERMUX_ISERV_BIN/$TERMUX_ISERV_BIN_NAME" ]] && return

	mkdir -p "$TERMUX_ISERV_BIN"

	declare -A checksums=(
		["aarch64"]="b0ac710974b7ed35aa72438190086d6d81c1e6e2ca8aec1d9149721b1ef0684b"
		["arm"]="467410b07a217e961e47150d8fa6aea3143d843981bc96e71f1b6d300e9db36e"
		["i686"]="a8f9e86c45db9a5747fb9c026e8ea7d9432bd22ea5274871b25c5619e0cdcc6b"
		["x86_64"]="95ed11f102eea61ed340c1a1b2fa372c35d67a2173d3b9d2f279e952f27ba31b"
	)

	local target="$TERMUX_HOST_PLATFORM"
	[[ "$TERMUX_ARCH" == "arm" ]] && target="armv7a-linux-androideabi"

	termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v$TERMUX_ISERV_VERSION/iserv-$TERMUX_ISERV_VERSION-$target.tar.xz" \
		"$TERMUX_ISERV_TAR" \
		"${checksums[$TERMUX_ARCH]}"

	tar xf "$TERMUX_ISERV_TAR" -C "$TERMUX_ISERV_BIN"
	chmod +x "$TERMUX_ISERV_BIN"/"$target"-ghc-iserv

	cat <<-EOF >"$TERMUX_ISERV_BIN/$TERMUX_ISERV_BIN_NAME"
		#!/bin/bash
		termux-proot-run-$TERMUX_ARCH $TERMUX_ISERV_BIN/$target-ghc-iserv "\$@"
	EOF

	chmod +x "$TERMUX_ISERV_BIN/$TERMUX_ISERV_BIN_NAME"

	# Clean up:
	rm -rf "$TERMUX_ISERV_TAR"
}
