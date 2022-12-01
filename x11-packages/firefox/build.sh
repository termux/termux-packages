TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/firefox
TERMUX_PKG_DESCRIPTION="Mozilla Firefox web browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=107.0.1
TERMUX_PKG_SRCURL=https://ftp.mozilla.org/pub/firefox/releases/${TERMUX_PKG_VERSION}/source/firefox-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=e29950b9ba9143b0d683dc18779bbe70bbd082533aff8f6a7af69b19533e0647
TERMUX_PKG_DEPENDS="at-spi2-atk, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-sysv-semaphore, libc++, libcairo, libcpufeatures, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxrandr, libxrender, libxtst, pango, pulseaudio"

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
	LDFLAGS+=" -landroid-shmem -landroid-sysv-semaphore -llog"

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
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
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/firefox.desktop $TERMUX_PREFIX/share/applications/firefox.desktop
}
