TERMUX_PKG_HOMEPAGE=https://ghostty.org
TERMUX_PKG_DESCRIPTION="Terminal emulation library from the Ghostty project"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.2"
TERMUX_PKG_SRCURL=(
	"https://release.files.ghostty.org/libghostty-vt/${TERMUX_PKG_VERSION}/libghostty-vt-${TERMUX_PKG_VERSION}.tar.gz"
	"https://release.files.ghostty.org/libghostty-vt/${TERMUX_PKG_VERSION}/libghostty-vt-${TERMUX_PKG_VERSION}-deps.tar.gz"
)
TERMUX_PKG_SHA256=(
	1dcafa8a3357f3a6bbf4f2696e61de611400c5469518716793dfffd35f008b3e
	c56156dbea82fdf71f13bf0d704cdf4393b6a04208d7f9691e0d7f60c7f9ca4d
)
TERMUX_PKG_BREAKS="ghostty (<< 1.4.0-1)"
TERMUX_PKG_REPLACES="ghostty (<< 1.4.0-1)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libghostty-vt.a
lib/pkgconfig/libghostty-vt-static.pc
"
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local latest_version
	latest_version="$(git ls-remote --tags --refs https://github.com/ghostty-org/ghostty 'vt-*' |
		grep -oP 'refs/tags/vt-\K[0-9]+(\.[0-9]+)+$' | sort -V | tail -n 1)" || :
	[[ -n "${latest_version}" ]] || termux_error_exit "Unable to get the latest libghostty-vt tag"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	termux_setup_zig

	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
}

termux_step_configure() {
	:
}

termux_step_make() {
	:
}

termux_step_make_install() {
	export ANDROID_NDK_HOME="${NDK-}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		# The build only accepts an NDK layout, so mock one from the device
		ANDROID_NDK_HOME="${TERMUX_PKG_TMPDIR}/ndk"
		local _usr="${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr"
		local _crt="${_usr}/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}"
		local _system_lib="/system/lib"
		[[ "${TERMUX_ARCH_BITS}" == "64" ]] && _system_lib="/system/lib64"
		rm -rf "${ANDROID_NDK_HOME}"
		mkdir -p "${_crt}"
		ln -s "${TERMUX_PREFIX}/include" "${_usr}/include"
		ln -s "${TERMUX_PREFIX}"/lib/crt*.o "${_system_lib}"/lib{c,dl,m}.so "${_crt}/"
	fi

	export ZIG_GLOBAL_CACHE_DIR="${TERMUX_PKG_TMPDIR}/zig-global-cache"
	rm -rf "${ZIG_GLOBAL_CACHE_DIR}"
	mkdir -p "${ZIG_GLOBAL_CACHE_DIR}"

	local _zig_target="${TERMUX_HOST_PLATFORM}.${TERMUX_PKG_API_LEVEL}"
	[[ "${TERMUX_ARCH}" == "i686" ]] && _zig_target="x86-linux-android.${TERMUX_PKG_API_LEVEL}"

	zig build \
		--prefix "${TERMUX_PREFIX}" \
		--system "${TERMUX_PKG_SRCDIR}/libghostty-vt-${TERMUX_PKG_VERSION}-deps" \
		-Dtarget="${_zig_target}" \
		-Dcpu=baseline \
		-Doptimize=ReleaseFast
}
