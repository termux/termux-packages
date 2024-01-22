TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/firefox
TERMUX_PKG_DESCRIPTION="Mozilla Firefox web browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="121.0.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.mozilla.org/pub/firefox/releases/${TERMUX_PKG_VERSION}/source/firefox-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=b3a4216e01eaeb9a7c6ef4659d8dcd956fbd90a78a8279ee3a598881e63e49ce
# ffmpeg and pulseaudio are dependencies through dlopen(3):
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures, libice, libsm"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_MAKE_PROCESSES=1

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
	[[ -z "${uptime_s}" ]] && e=1
	[[ "${uptime_s}" == 0 ]] && e=1
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
	termux_setup_nodejs
	termux_setup_rust

	# https://github.com/rust-lang/rust/issues/49853
	# https://github.com/rust-lang/rust/issues/45854
	# Out of memory when building gkrust
	# CI shows (signal: 9, SIGKILL: kill)
	case "${TERMUX_ARCH}" in
	aarch64|arm|i686|x86_64) RUSTFLAGS+=" -C debuginfo=1" ;;
	esac

	cargo install cbindgen

	sed \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|" \
		-i "${TERMUX_PKG_SRCDIR}"/build/moz.configure/rust.configure

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	# https://reviews.llvm.org/D141184
	CXXFLAGS+=" -U__ANDROID__ -D_LIBCPP_HAS_NO_C11_ALIGNED_ALLOC"
	LDFLAGS+=" -landroid-shmem -llog"
}

termux_step_configure() {
	python3 "${TERMUX_PKG_SRCDIR}"/configure.py \
		--target=${TERMUX_HOST_PLATFORM} \
		--prefix=${TERMUX_PREFIX} \
		--with-sysroot=${TERMUX_PREFIX} \
		--allow-addon-sideload \
		--disable-accessibility \
		--disable-address-sanitizer-reporter \
		--disable-crashreporter \
		--disable-dbus \
		--disable-elf-hack \
		--disable-hardening \
		--disable-jemalloc \
		--disable-necko-wifi \
		--disable-parental-controls \
		--disable-synth-speechd \
		--disable-webspeech \
		--disable-sandbox \
		--disable-tests \
		--disable-updater \
		--enable-audio-backends=pulseaudio \
		--enable-minify=properties \
		--enable-mobile-optimize \
		--enable-printing \
		--enable-system-ffi \
		--enable-system-pixman \
		--with-branding=browser/branding/official \
		--with-system-icu \
		--with-system-jpeg=${TERMUX_PREFIX} \
		--with-system-libevent \
		--with-system-libvpx \
		--with-system-nspr \
		--with-system-nss \
		--with-system-webp \
		--with-system-zlib \
		--without-wasm-sandboxed-libraries
}

termux_step_post_make_install() {
	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" "${TERMUX_PKG_BUILDER_DIR}/firefox.desktop"

	# https://github.com/termux/termux-packages/issues/18429
	# https://phabricator.services.mozilla.com/D181687
	# Android 8.x and older not support "-z pack-relative-relocs" / DT_RELR
	local r=$("${READELF}" -d "${TERMUX_PREFIX}/bin/firefox")
	if [[ -n "$(echo "${r}" | grep "(RELR)")" ]]; then
		termux_error_exit "DT_RELR is unsupported on Android 8.x and older\n${r}"
	fi
}
