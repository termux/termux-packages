TERMUX_PKG_HOMEPAGE=https://ghostty.org
TERMUX_PKG_DESCRIPTION="Fast, feature-rich, GPU-accelerated terminal emulator (GTK4 + X11)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.3.1"
# Release tarball ships prebuilt GTK resources
TERMUX_PKG_SRCURL="https://release.files.ghostty.org/${TERMUX_PKG_VERSION}/ghostty-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3349d25600ffbda281197a18314f7d18791969cffe9474f0ff16a45a9ebfccdb
TERMUX_PKG_DEPENDS="fontconfig, freetype, glib, gtk4, harfbuzz, libadwaita, libbz2, libpng, libx11, oniguruma, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
# 32-bit unsupported
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=false

# Must match minimum_zig_version in build.zig.zon
TERMUX_ZIG_VERSION="0.15.2"

termux_step_pre_configure() {
	termux_setup_zig

	# NDK flags must not leak into zig
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

	export ZIG_GLOBAL_CACHE_DIR="${TERMUX_PKG_BUILDDIR}/.zig-global-cache"

	# --libc also applies to the host tool ghostty-build-data; build it without libc
	local _build_data="${TERMUX_PKG_SRCDIR}/src/main_build_data.zig"
	local _resources="${TERMUX_PKG_SRCDIR}/src/build/GhosttyResources.zig"
	grep -q 'std.heap.c_allocator' "${_build_data}" ||
		termux_error_exit "Expected std.heap.c_allocator not found in ${_build_data}"
	grep -q 'build_data_exe.linkLibC();' "${_resources}" ||
		termux_error_exit "Expected build_data_exe.linkLibC() not found in ${_resources}"
	sed -i 's/std\.heap\.c_allocator/std.heap.page_allocator/' "${_build_data}"
	sed -i '/build_data_exe\.linkLibC();/d' "${_resources}"
}

termux_step_make() {
	# Android ABI (not musl): GTK4 and libadwaita are bionic libs
	# pkg/android-ndk needs this variable
	export ANDROID_NDK_HOME="${NDK}"
	local _sysroot="${NDK}/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
	local _libc_file="${TERMUX_PKG_TMPDIR}/zig-libc.txt"
	cat > "${_libc_file}" <<-EOF
		include_dir=${_sysroot}/usr/include
		sys_include_dir=${_sysroot}/usr/include/${TERMUX_HOST_PLATFORM}
		crt_dir=${_sysroot}/usr/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}
		msvc_lib_dir=
		kernel32_lib_dir=
		gcc_dir=
	EOF

	# Ghostty links -lbzip2, Termux ships libbz2. Alias kept outside $TERMUX_PREFIX
	local _bz2_compat="${TERMUX_PKG_TMPDIR}/bz2-compat"
	mkdir -p "${_bz2_compat}/lib"
	ln -sf "${TERMUX_PREFIX}/lib/libbz2.so" "${_bz2_compat}/lib/libbzip2.so"

	# Wayland off: Termux only has gtk-layer-shell for GTK3
	zig build \
		--prefix "${TERMUX_PKG_TMPDIR}/ghostty-prefix" \
		--libc "${_libc_file}" \
		--search-prefix "${TERMUX_PREFIX}" \
		--search-prefix "${_bz2_compat}" \
		-Dtarget="${TERMUX_ARCH}-linux-android.${TERMUX_PKG_API_LEVEL}" \
		-Dcpu=baseline \
		-Doptimize=ReleaseFast \
		-Dapp-runtime=gtk \
		-Dgtk-x11=true \
		-Dgtk-wayland=false \
		-Dpatch-rpath="${TERMUX_PREFIX}/lib" \
		-Di18n=false \
		-Demit-docs=false \
		-fsys=freetype \
		-fsys=harfbuzz \
		-fsys=fontconfig \
		-fsys=libpng \
		-fsys=zlib \
		-fsys=oniguruma
}

termux_step_make_install() {
	# .desktop/D-Bus/systemd files contain the staging path
	local _staging="${TERMUX_PKG_TMPDIR}/ghostty-prefix"
	grep -rIl --null -F "${_staging}" "${_staging}/share" "${_staging}/lib" 2>/dev/null |
		xargs -0 -r sed -i "s|${_staging}|${TERMUX_PREFIX}|g"

	cp -a "${_staging}/." "${TERMUX_PREFIX}/"
}
