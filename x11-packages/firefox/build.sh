TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/firefox
TERMUX_PKG_DESCRIPTION="Mozilla Firefox web browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=117.0
TERMUX_PKG_SRCURL=https://ftp.mozilla.org/pub/firefox/releases/${TERMUX_PKG_VERSION}/source/firefox-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=fa524cb9a63334d74ef996f3cbaf1559b5836f6c8ef6e890fa20846029242ac7
# ffmpeg and pulseaudio are dependencies through dlopen(3):
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures, libice, libsm"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_MAKE_PROCESSES=1

termux_pkg_auto_update() {
	# https://archive.mozilla.org/pub/firefox/releases/latest/README.txt
	local api_url="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
	local latest_version=$(curl -s "${api_url}" | sed -nE "s/.*firefox-(.*).tar.bz2.*/\1/p")
	if [[ -z "${latest_version}" ]];  then
		echo "WARN: Unable to get latest version from upstream! Try again later." >&2
		return
	fi

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -i -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' ${f}
}

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_nodejs
	cargo install cbindgen

	sed -i -e "s|%TERMUX_CARGO_TARGET_NAME%|$CARGO_TARGET_NAME|" $TERMUX_PKG_SRCDIR/build/moz.configure/rust.configure

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	CXXFLAGS+=" -U__ANDROID__"
	LDFLAGS+=" -landroid-shmem -llog"
}

termux_step_configure() {
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		--with-sysroot=$TERMUX_PREFIX \
		--enable-audio-backends=pulseaudio \
		--enable-minify=properties \
		--enable-mobile-optimize \
		--enable-printing \
		--disable-jemalloc \
		--enable-system-ffi \
		--enable-system-pixman \
		--with-system-icu \
		--with-system-jpeg=$TERMUX_PREFIX \
		--with-system-libevent \
		--with-system-libvpx \
		--with-system-nspr \
		--with-system-nss \
		--with-system-webp \
		--with-system-zlib \
		--without-wasm-sandboxed-libraries \
		--with-branding=browser/branding/official \
		--disable-sandbox \
		--disable-tests \
		--disable-accessibility \
		--disable-crashreporter \
		--disable-dbus \
		--disable-necko-wifi \
		--disable-updater \
		--disable-hardening \
		--disable-parental-controls \
		--disable-webspeech \
		--disable-synth-speechd \
		--disable-elf-hack \
		--disable-address-sanitizer-reporter \
		--allow-addon-sideload
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/firefox.desktop $TERMUX_PREFIX/share/applications/firefox.desktop
}
