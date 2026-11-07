TERMUX_PKG_HOMEPAGE=https://www.kernel.org/
TERMUX_PKG_DESCRIPTION="User-Mode Linux kernel (runs as an ordinary userspace process; aarch64 and x86_64)"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
# Pinned to the linux-um-arm64 port base (7.2 series). The aarch64 build uses
# the port's patch series in patches-aarch64/ (`git format-patch
# next..um-arm64` from the port; wifi/rtl8188eus extra intentionally
# excluded, see below). Upstream UML already supports the x86_64 subarch,
# so that build needs none of the series: only the static-link Kconfig fix
# in patches-x86_64/ plus the vendored docker.config. Subdirectories are
# applied per arch in termux_step_pre_configure (the build system only
# auto-applies top-level *.patch).
TERMUX_PKG_VERSION=7.2.11
TERMUX_PKG_SRCURL=https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fd0fc479f983a8c05313f13e9c36330fe6651cf725396748c40d5cd93fa1e6a4
TERMUX_PKG_AUTO_UPDATE=false
# ARCH=um only makes sense where guest userspace can run as real instructions
# on the real CPU (CONFIG_COMPAT is off): aarch64 and x86_64 hosts. 32-bit
# ARMs and x86 are out (upstream UML has no arm32 subarch at all).
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
# Oldest bionic declaring everything UML uses: statx(30), getrandom(28).
# Runtime therefore needs Android 11+. See tools/um-arm64/harness/build-bionic.sh
# (API variable) in patch 0027.
TERMUX_PKG_API_LEVEL=30
TERMUX_PKG_BUILD_DEPENDS="bc, bison, flex, libelf, openssl, perl, python"

_um_setup_bionic_toolchain() {
	# Replicates tools/um-arm64/harness/build-bionic.sh: kbuild's own
	# --target=aarch64-linux-gnu must be beaten by appending the Android
	# target *after* it (clang takes the last one), so never override CC
	# (that would also disable kbuild's compiler probing).
	local ndk_tool="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin"
	[ -x "$ndk_tool/clang" ] || termux_error_exit "Android NDK clang not found at $ndk_tool"
	local shim="$TERMUX_PKG_BUILDDIR/bionic-shim"
	mkdir -p "$shim"
	cat >"$shim/clang" <<EOF
#!/bin/sh
exec $ndk_tool/clang "\$@" --target=$UM_NDK_TARGET
EOF
	cp "$shim/clang" "$shim/clang++"
	chmod +x "$shim/clang" "$shim/clang++"
	local t
	for t in ld.lld llvm-ar llvm-nm llvm-objcopy llvm-objdump llvm-readelf llvm-strip; do
		ln -sf "$ndk_tool/$t" "$shim/$t"
	done
	export PATH="$shim:$ndk_tool:$PATH"
	# fixdep, kconfig conf and friends run on the build machine, so they
	# must be built with a real host compiler producing runnable x86_64
	# binaries. NB: never resolve this via PATH here: PATH above already
	# contains the NDK/shim clang, which targets aarch64-linux-android and
	# yields host tools that fail with "./fixdep: not found" (missing
	# /system/bin/linker64). The docker image provides a host toolchain
	# (the same one TERMUX_PKG_HOSTBUILD packages use).
	local pair cc cxx
	for pair in "gcc g++" "clang clang++" "cc c++"; do
		cc="${pair%% *}"
		cxx="${pair##* }"
		if [ -x "/usr/bin/$cc" ] && [ -x "/usr/bin/$cxx" ]; then
			UM_HOSTCC="/usr/bin/$cc"
			UM_HOSTCXX="/usr/bin/$cxx"
			break
		fi
	done
	[ -n "${UM_HOSTCC:-}" ] || termux_error_exit "No host C compiler found for kbuild host tools"
	# Smoke test: a host tool that cannot execute must fail here with a
	# clear message, not later as "scripts/basic/fixdep: not found".
	echo 'int main(void){return 0;}' >"$TERMUX_PKG_BUILDDIR/.hostcc-test.c"
	"$UM_HOSTCC" -o "$TERMUX_PKG_BUILDDIR/.hostcc-test" \
		"$TERMUX_PKG_BUILDDIR/.hostcc-test.c" &&
		"$TERMUX_PKG_BUILDDIR/.hostcc-test" ||
		termux_error_exit "Host compiler $UM_HOSTCC produces binaries that cannot execute"
	rm -f "$TERMUX_PKG_BUILDDIR/.hostcc-test" "$TERMUX_PKG_BUILDDIR/.hostcc-test.c"
}

_um_kbuild() {
	make -C "$TERMUX_PKG_SRCDIR" O="$TERMUX_PKG_BUILDDIR" \
		ARCH=um SUBARCH="$UM_SUBARCH" LLVM=1 \
		HOSTCC="$UM_HOSTCC" HOSTCXX="$UM_HOSTCXX" \
		-j"$TERMUX_PKG_MAKE_PROCESSES" "$@"
}

termux_step_pre_configure() {
	# Per-arch shape. Upstream UML already supports the x86_64 subarch, so
	# that build needs none of the arm64 port series: only the static-link
	# Kconfig fix in patches-x86_64/. The aarch64 build keeps the full
	# port series in patches-aarch64/, untouched and in numeric order.
	cd "$TERMUX_PKG_SRCDIR"
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		export UM_SUBARCH=arm64
		export UM_NDK_TARGET="aarch64-linux-android${TERMUX_PKG_API_LEVEL}"
		export UM_LD_LINUX="ld-linux-aarch64.so.1"
		export UM_KBUILD_DEFCONFIG=defconfig
		export UM_PATCH_SUBDIR=patches-aarch64
		export UM_DOCKER_CONFIG="$TERMUX_PKG_SRCDIR/tools/um-arm64/config/docker.config"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		export UM_SUBARCH=x86
		export UM_NDK_TARGET="x86_64-linux-android${TERMUX_PKG_API_LEVEL}"
		export UM_LD_LINUX="ld-linux-x86-64.so.2"
		# x86 (not x86_64): that is the canonical UML subarch name (what
		# uname -m maps to). HEADER_ARCH, Makefile.um and KBUILD_DEFCONFIG
		# (arch/um/configs/x86_64_defconfig, which exists upstream)
		# resolve identically either way, but every doc and the port's
		# own comments use x86.
		# patches-x86_64/ carries the static-link Kconfig fix plus the
		# compiler-attribute fallbacks for USER_CFLAGS objects (the NDK
		# sysroot shadows linux/compiler_types.h with a stub). The first
		# x86_64 build will also tell whether it needs any of the bionic
		# link-vmlinux.sh changes the arm64 series carries; those belong
		# in patches-x86_64/ if so.
		export UM_KBUILD_DEFCONFIG=defconfig
		export UM_PATCH_SUBDIR=patches-x86_64
		export UM_DOCKER_CONFIG="$TERMUX_PKG_BUILDER_DIR/docker.config"
	else
		termux_error_exit "linux-kernel-um: unsupported arch $TERMUX_ARCH"
	fi
	local p
	for p in "$TERMUX_PKG_BUILDER_DIR/$UM_PATCH_SUBDIR"/*.patch; do
		[ -e "$p" ] || continue
		echo "Applying arch patch: $(basename "$p")"
		patch --silent -p1 <"$p" || termux_error_exit "Failed to apply $p"
	done
}

termux_step_configure() {
	mkdir -p "$TERMUX_PKG_BUILDDIR"
	_um_setup_bionic_toolchain
	export KBUILD_BUILD_TIMESTAMP="Thu Jan  1 00:00:00 UTC 1970"
	export KBUILD_BUILD_USER=um
	export KBUILD_BUILD_HOST="$TERMUX_ARCH"
	_um_kbuild "$UM_KBUILD_DEFCONFIG"
	# Static: Android ships no dynamic loader (no /lib/$UM_LD_LINUX).
	# UML_NET_VECTOR stays ON: it is the guest's only network device
	# (passt over vector fd transport); disabling it boots with no
	# interface at all.
	"$TERMUX_PKG_SRCDIR/scripts/config" --file "$TERMUX_PKG_BUILDDIR/.config" \
		-e STATIC_LINK -e UML_NET_VECTOR
	# No loadable modules, mirroring the port's arm64_defconfig
	# ("# CONFIG_MODULES is not set"): the guest needs nothing from them
	# (docker.config is all built-in), an appliance kernel stays
	# monolithic, and .ko files fail the package symbol check (their
	# undefined symbols resolve against the running kernel at insmod,
	# which the userspace-library check cannot model).
	if [ "$TERMUX_ARCH" = "x86_64" ]; then
		"$TERMUX_PKG_SRCDIR/scripts/config" --file "$TERMUX_PKG_BUILDDIR/.config" \
			-d MODULES
	fi
	# Guest container support (Docker/overlay2): the docker.config fragment,
	# taken from moby's contrib/check-config.sh (from the port series on
	# aarch64, vendored in this directory on x86_64). Merged before
	# olddefconfig so dependencies resolve. Without it the guest kernel
	# lacks OVERLAY_FS/VETH/BRIDGE_NETFILTER/MEMCG and dockerd cannot run
	# containers.
	"$TERMUX_PKG_SRCDIR/scripts/kconfig/merge_config.sh" -m \
		-O "$TERMUX_PKG_BUILDDIR" "$TERMUX_PKG_BUILDDIR/.config" \
		"$UM_DOCKER_CONFIG" >/dev/null
	_um_kbuild olddefconfig
}

termux_step_make() {
	_um_kbuild
}

termux_step_make_install() {
	[ -f "$TERMUX_PKG_BUILDDIR/linux" ] || termux_error_exit "kbuild did not produce \$O/linux"
	install -Dm700 "$TERMUX_PKG_BUILDDIR/linux" "$TERMUX_PREFIX/bin/linux"
	# Optional stub override (default is a memfd): `linux ... stub_exe=<path>`.
	# Must stay executable: the kernel execs it via execveat(AT_EMPTY_PATH),
	# which requires the x bit (kbuild ships it 755; do not strip it here).
	local stub="$TERMUX_PKG_BUILDDIR/arch/um/kernel/skas/stub_exe"
	if [ -f "$stub" ]; then
		install -Dm700 "$stub" "$TERMUX_PREFIX/share/linux-kernel-um/stub_exe"
	fi
	# Loadable modules (supported by the series, patch 0026). depmod cannot
	# run meaningfully against the guest tree here, so skip it: run depmod
	# once inside the guest rootfs instead. Skipped entirely without
	# CONFIG_MODULES (the x86_64 config above disables them).
	if grep -q '^CONFIG_MODULES=y' "$TERMUX_PKG_BUILDDIR/.config"; then
		_um_kbuild modules_install \
			INSTALL_MOD_PATH="$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX" \
			DEPMOD=true
	fi
}
