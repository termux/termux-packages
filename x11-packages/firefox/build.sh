TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/firefox
TERMUX_PKG_DESCRIPTION="Mozilla Firefox web browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="134.0.2"
TERMUX_PKG_SRCURL=https://archive.mozilla.org/pub/firefox/releases/${TERMUX_PKG_VERSION}/source/firefox-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=6c6eb7ff13fa689c5cace23a28533361d1ca29158329b6f1c2f2d1c91c53dd27
# ffmpeg and pulseaudio are dependencies through dlopen(3):
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-spawn, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures, libice, libsm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	# https://archive.mozilla.org/pub/firefox/releases/latest/README.txt
	local e=0
	local api_url="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
	local api_url_r=$(curl -s "${api_url}")
	local latest_version=$(echo "${api_url_r}" | sed -nE "s/.*firefox-(.*).tar.bz2.*/\1/p")
	[[ -z "${api_url_r}" ]] && e=1
	[[ -z "${latest_version}" ]] && e=1

	local uptime_now=$(cat /proc/uptime)
	local uptime_s="${uptime_now//.*}"
	local uptime_h_limit=2
	local uptime_s_limit=$((uptime_h_limit*60*60))
	[[ -z "${uptime_s}" ]] && [[ "$(uname -o)" != "Android" ]] && e=1
	[[ "${uptime_s}" == 0 ]] && [[ "$(uname -o)" != "Android" ]] && e=1
	[[ "${uptime_s}" -gt "${uptime_s_limit}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		api_url_r=${api_url_r}
		latest_version=${latest_version}
		uptime_now=${uptime_now}
		uptime_s=${uptime_s}
		uptime_s_limit=${uptime_s_limit}
		EOL
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' -i ${f}
}

termux_step_pre_configure() {
	# XXX: flang toolchain provides libclang.so
	termux_setup_flang
	local __fc_dir="$(dirname $(command -v $FC))"
	local __flang_toolchain_folder="$(realpath "$__fc_dir"/..)"
	if [ ! -d "$TERMUX_PKG_TMPDIR/firefox-toolchain" ]; then
		rm -rf "$TERMUX_PKG_TMPDIR"/firefox-toolchain-tmp
		mv "$__flang_toolchain_folder" "$TERMUX_PKG_TMPDIR"/firefox-toolchain-tmp

		cp "$(command -v "$CC")" "$TERMUX_PKG_TMPDIR"/firefox-toolchain-tmp/bin/
		cp "$(command -v "$CXX")" "$TERMUX_PKG_TMPDIR"/firefox-toolchain-tmp/bin/
		cp "$(command -v "$CPP")" "$TERMUX_PKG_TMPDIR"/firefox-toolchain-tmp/bin/

		mv "$TERMUX_PKG_TMPDIR"/firefox-toolchain-tmp "$TERMUX_PKG_TMPDIR"/firefox-toolchain
	fi
	export PATH="$TERMUX_PKG_TMPDIR/firefox-toolchain/bin:$PATH"

	termux_setup_nodejs
	termux_setup_rust

	# https://github.com/rust-lang/rust/issues/49853
	# https://github.com/rust-lang/rust/issues/45854
	# Out of memory when building gkrust
	# CI shows (signal: 9, SIGKILL: kill)
	if [ "$TERMUX_DEBUG_BUILD" = false ]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C debuginfo=1"
	fi

	cargo install cbindgen

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	export BINDGEN_CFLAGS="--target=$CCTERMUX_HOST_PLATFORM --sysroot=$TERMUX_PKG_TMPDIR/firefox-toolchain/sysroot"
	local env_name=BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export $env_name="$BINDGEN_CFLAGS"

	# https://reviews.llvm.org/D141184
	CXXFLAGS+=" -U__ANDROID__ -D_LIBCPP_HAS_NO_C11_ALIGNED_ALLOC"
	LDFLAGS+=" -landroid-shmem -landroid-spawn -llog"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# For symbol android_getCpuFeatures
		LDFLAGS+=" -l:libndk_compat.a"
	fi
}

termux_step_configure() {
	if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
		termux_step_pre_configure
		cd $TERMUX_PKG_SRCDIR
	fi

	sed \
		-e "s|@TERMUX_HOST_PLATFORM@|${TERMUX_HOST_PLATFORM}|" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|" \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|" \
		$TERMUX_PKG_BUILDER_DIR/mozconfig.cfg > .mozconfig

	if [ "$TERMUX_DEBUG_BUILD" = true ]; then
		cat >>.mozconfig - <<END
ac_add_options --enable-debug-symbols
ac_add_options --disable-install-strip
END
	fi

	./mach configure
}

termux_step_make() {
	./mach build
	./mach buildsymbols
}

termux_step_make_install() {
	./mach install

	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" "${TERMUX_PKG_BUILDER_DIR}/firefox.desktop"
}

termux_step_post_make_install() {
	# https://github.com/termux/termux-packages/issues/18429
	# https://phabricator.services.mozilla.com/D181687
	# Android 8.x and older not support "-z pack-relative-relocs" / DT_RELR
	local r=$("${READELF}" -d "${TERMUX_PREFIX}/bin/firefox")
	if [[ -n "$(echo "${r}" | grep "(RELR)")" ]]; then
		termux_error_exit "DT_RELR is unsupported on Android 8.x and older\n${r}"
	fi
}
