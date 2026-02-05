TERMUX_PKG_HOMEPAGE=https://www.thunderbird.net
TERMUX_PKG_DESCRIPTION="Unofficial Thunderbird email client"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="147.0.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://archive.mozilla.org/pub/thunderbird/releases/${TERMUX_PKG_VERSION}/source/thunderbird-${TERMUX_PKG_VERSION}.source.tar.xz"
TERMUX_PKG_SHA256=3e8a52c552a983340ced4c8f44ee37ae5028a2c9d717b9b49ee37ae72a6615ce
TERMUX_PKG_DEPENDS="botan3, ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-spawn, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libotr, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures, libice, libsm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# NOTE:
# Most of Thunderbird's patches are shared with Firefox.
# To avoid issues and reduce duplication the shared 00XX-${topic}.patch files
# are symlinks to the patches in x11-packages/firefox
# Thunderbird specific patches should start at 1001-${topic}.patch

termux_pkg_auto_update() {
	# https://archive.mozilla.org/pub/thunderbird/releases/latest/README.txt
	local e=0
	local api_url="https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=en-US"
	local api_url_r=$(curl -s "${api_url}")
	local latest_version=$(echo "${api_url_r}" | sed -nE "s/.*thunderbird-(.*).tar.xz.*/\1/p")
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

	# Update Cargo.toml to use the patched cc
	sed -i 's|^\(\[patch\.crates-io\]\)$|\1\ncc = { path = "third_party/rust/cc" }|g' \
		Cargo.toml
	(
		termux_setup_rust
		cargo update -p cc
	)
}

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	# Out of memory when building gkrust
	if [ "$TERMUX_DEBUG_BUILD" = false ]; then
		local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C debuginfo=1"
	fi

	cargo install cbindgen

	HOST_CC="$(command -v clang)"
	HOST_CXX="$(command -v clang++)"
	export HOST_CC HOST_CXX

	export BINDGEN_CFLAGS="--target=$CCTERMUX_HOST_PLATFORM --sysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot"
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

	# vendor crates that otherwise cause 'error: failed to calculate checksum of... .gitmodules'
	# when '--frozen' is removed because the thunderbird archive doesn't contain any .gitmodules files,
	# then vendor the cc crate last so that the CFLAGS-related patch can be applied to it
	local crate dir crate_src_dir crate_dest_dir patch
	for crate in minimal-lexical cubeb-sys sfv glslopt cc; do
		dir="$TERMUX_PKG_SRCDIR/comm/third_party/rust"
		crate_src_dir="$dir/$crate"
		crate_dest_dir="$crate_src_dir-custom"
		cp -r "$crate_src_dir" "$crate_dest_dir"
		sed -i "/\[patch.crates-io\]/a $crate = { path = \"$crate_dest_dir\" }" "$TERMUX_PKG_SRCDIR/comm/rust/Cargo.toml"
	done

	patch="$TERMUX_PKG_BUILDER_DIR/0029-rust-cc-do-not-concatenates-all-the-CFLAGS.patch"
	echo "Applying patch: $patch"
	patch -p4 -d "$crate_dest_dir" < "$patch"
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
		"$TERMUX_PKG_BUILDER_DIR/mozconfig.cfg" > .mozconfig

	if [ "$TERMUX_DEBUG_BUILD" = true ]; then
		cat >>.mozconfig - <<END
ac_add_options --enable-debug-symbols
ac_add_options --disable-install-strip
END
	fi

	./mach configure
}

termux_step_make() {
	./mach build -j "$TERMUX_PKG_MAKE_PROCESSES"
	./mach buildsymbols
}

termux_step_make_install() {
	./mach install

	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" "${TERMUX_PKG_BUILDER_DIR}/thunderbird.desktop"

	# Install icons as Arch Linux does
	local i theme=nightly
	for i in 16 22 24 32 48 64 128 256; do
		install -Dvm644 "comm/mail/branding/$theme/default$i.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${i}x${i}/apps/$TERMUX_PKG_NAME.png"
	done
	install -Dvm644 "comm/mail/branding/$theme/content/about-logo.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/192x192/apps/$TERMUX_PKG_NAME.png"
	install -Dvm644 "comm/mail/branding/$theme/content/about-logo@2x.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/384x384/apps/$TERMUX_PKG_NAME.png"
	install -Dvm644 "comm/mail/branding/$theme/content/about-logo.svg" \
		"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/$TERMUX_PKG_NAME.svg"
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
