TERMUX_PKG_HOMEPAGE=https://www.thunderbird.net
TERMUX_PKG_DESCRIPTION="Unofficial Thunderbird email client"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="128.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://archive.mozilla.org/pub/thunderbird/releases/${TERMUX_PKG_VERSION}esr/source/thunderbird-${TERMUX_PKG_VERSION}esr.source.tar.xz"
TERMUX_PKG_SHA256=81f43a2680412a6afdb5fdf6b8296c92d0d6812892399b174723c4f753d5429f
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-spawn, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libotr, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross, libcpufeatures, libice, libsm"
TERMUX_PKG_BUILD_IN_SRC=true
# Mozilla does not provide a simple way to find the latest ESR release
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d+\.\d+\.\d+(?=esr/)'
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	# Adapted from the auto_update function in x11/firefox and packages/ncdu.
	# Unfortunately there is no 'latest-esr/' directory for Thunderbird.
	# https://archive.mozilla.org/pub/thunderbird/releases/latest/README.txt
	local api_url latest_esr
	api_url="https://archive.mozilla.org/pub/thunderbird/releases/"
	latest_esr="$(curl -s "$api_url" \
		| grep -oP "$TERMUX_PKG_UPDATE_VERSION_REGEXP" \
		| sort -V \
		| tail -n1)"

	if [[ "${latest_esr}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${latest_esr}'."
		return
	fi

	# We want to avoid re-filtering the version.
	# It's already cleaned up, so unset the regexp.
	# See: https://github.com/termux/termux-packages/issues/20836
	# See also: packages/taplo/build.sh
	unset TERMUX_PKG_UPDATE_VERSION_REGEXP
	termux_pkg_upgrade_version "${latest_esr}"
}


termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' -i ${f}
}

termux_step_pre_configure() {
	# XXX: flang toolchain provides libclang.so
	termux_setup_flang
	local __fc_dir __flang_toolchain_folder
	__fc_dir="$(dirname "$(command -v "$FC")")"
	__flang_toolchain_folder="$(realpath "$__fc_dir"/..)"
	if [ ! -d "$TERMUX_PKG_TMPDIR/thunderbird-toolchain" ]; then
		rm -rf "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain-tmp
		mv "$__flang_toolchain_folder" "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain-tmp

		cp "$(command -v "$CC")" "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain-tmp/bin/
		cp "$(command -v "$CXX")" "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain-tmp/bin/
		cp "$(command -v "$CPP")" "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain-tmp/bin/

		mv "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain-tmp "$TERMUX_PKG_TMPDIR"/thunderbird-toolchain
	fi
	export PATH="$TERMUX_PKG_TMPDIR/thunderbird-toolchain/bin:$PATH"

	termux_setup_nodejs
	termux_setup_rust

	# Out of memory when building gkrust
	if [ "$TERMUX_DEBUG_BUILD" = false ]; then
		case "${TERMUX_ARCH}" in
		aarch64|arm|i686|x86_64) RUSTFLAGS+=" -C debuginfo=1" ;;
		esac
	fi

	cargo install cbindgen

	HOST_CC="$(command -v clang)"
	HOST_CXX="$(command -v clang++)"
	export HOST_CC HOST_CXX

	export BINDGEN_CFLAGS="--target=$CCTERMUX_HOST_PLATFORM --sysroot=$TERMUX_PKG_TMPDIR/thunderbird-toolchain/sysroot"
	local env_name=BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export "$env_name"="$BINDGEN_CFLAGS"

	# https://reviews.llvm.org/D141184
	CXXFLAGS+=" -U__ANDROID__ -D_LIBCPP_HAS_NO_C11_ALIGNED_ALLOC"
	LDFLAGS+=" -landroid-shmem -landroid-spawn -llog"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# For symbol android_getCpuFeatures
		LDFLAGS+=" -l:libndk_compat.a"
	fi
}

termux_step_configure() {
	sed \
		-e "s|@TERMUX_HOST_PLATFORM@|${TERMUX_HOST_PLATFORM}|" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|" \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|" \
		"$TERMUX_PKG_BUILDER_DIR/mozconfig.cfg" > .mozconfig

	if [ "$TERMUX_DEBUG_BUILD" = true ]; then
		cat >>.mozconfig - <<END
ac_add_options --enable-debug-symbols
ac_add_options --disable-install-strip
END
	fi

	./mach configure
	./mach tb-rust vendor
}

termux_step_make() {
	# XXX: Try max 10 times
	for t in $(seq 1 10); do
		if ./mach build --keep-going; then
			break
		else
			if [ "$t" = "10" ]; then
				termux_error_exit "Giving up after 10 attempts"
			fi
		fi
	done

	./mach buildsymbols
}

termux_step_make_install() {
	./mach install

	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" "${TERMUX_PKG_BUILDER_DIR}/thunderbird.desktop"
}

termux_step_post_make_install() {
	# https://github.com/termux/termux-packages/issues/21511
	# https://phabricator.services.mozilla.com/D181687
	# Android 8.x and older not support "-z pack-relative-relocs" / DT_RELR
	local r
	r=$("${READELF}" -d "${TERMUX_PREFIX}/bin/thunderbird")
	if [[ -n "$(echo "${r}" | grep "(RELR)")" ]]; then
		termux_error_exit "DT_RELR is unsupported on Android 8.x and older\n${r}"
	fi
}
