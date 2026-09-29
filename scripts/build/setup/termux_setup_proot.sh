# shellcheck shell=bash
# This provides an utility to run binaries under termux environment via proot.
termux_setup_proot() {
	local TERMUX_PROOT_VERSION=5.3.0
	local TERMUX_QEMU_VERSION=7.2.0-1
	local TERMUX_PROOT_BIN="$TERMUX_COMMON_CACHEDIR/proot-bin-$TERMUX_ARCH"
	local TERMUX_PROOT_QEMU=""
	local TERMUX_PROOT_BIN_NAME="termux-proot-run"

	export PATH="$TERMUX_PROOT_BIN:$PATH"

	[[ -d "$TERMUX_PROOT_BIN" ]] && return

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
		termux_download https://github.com/multiarch/qemu-user-static/releases/download/v"$TERMUX_QEMU_VERSION"/qemu-"${TERMUX_ARCH/i686/i386}"-static \
			"$TERMUX_PROOT_BIN"/qemu-"$TERMUX_ARCH" \
			"${checksums[$TERMUX_ARCH]}"
		chmod +x "$TERMUX_PROOT_BIN"/qemu-"$TERMUX_ARCH"
		TERMUX_PROOT_QEMU="-q $TERMUX_PROOT_BIN/qemu-$TERMUX_ARCH"
	fi

	# NOTE: We include current PATH too so that host binaries also become available under proot.
	cat <<-EOF >"$TERMUX_PROOT_BIN/$TERMUX_PROOT_BIN_NAME"
		#!/bin/bash
		env -i \
			PATH="$TERMUX_PREFIX/bin:$PATH" \
			ANDROID_DATA=/data \
			ANDROID_ROOT=/system \
			HOME=$TERMUX_ANDROID_HOME \
			LANG=en_US.UTF-8 \
			PREFIX=$TERMUX_PREFIX \
			TERM=$TERM \
			TZ=UTC \
			$TERMUX_PROOT_EXTRA_ENV_VARS \
			$TERMUX_PROOT_BIN/proot $TERMUX_PROOT_QEMU -R / "\$@"
	EOF
	chmod +x "$TERMUX_PROOT_BIN/$TERMUX_PROOT_BIN_NAME"
}
