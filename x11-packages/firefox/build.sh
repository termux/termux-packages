TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/firefox
TERMUX_PKG_DESCRIPTION="Mozilla Firefox web browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=105.0.3
TERMUX_PKG_SRCURL=http://ftp.mozilla.org/pub/firefox/releases/${TERMUX_PKG_VERSION}/source/firefox-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=f2fa1e03aecdd4dca0bcda94fd228d3a9ef3635862a2c140f8982d32ae7761e7
TERMUX_PKG_DEPENDS="at-spi2-atk, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-shmem, libandroid-sysv-semaphore, libcairo, libffi, libice, libsm, libx11, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxrandr, libxrender, libxtst, pango"

termux_step_pre_configure() {
	local _CFLAGS="$CFLAGS"

	termux_setup_rust
	termux_setup_nodejs
	cargo install cbindgen

	sed -i -e "s|%TERMUX_CARGO_TARGET_NAME%|$CARGO_TARGET_NAME|" $TERMUX_PKG_SRCDIR/build/moz.configure/rust.configure

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	export CFLAGS="$_CFLAGS -DNO_NSPR_10_SUPPORT -DHAVE_STDINT_H -DMOZ_X11"
	CXXFLAGS+=" -U__ANDROID__ -DMOZ_X11"
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

	# SIGKILL while building gkrust
	TERMUX_MAKE_PROCESSES=1
}

termux_step_configure() {
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		--target=$TERMUX_HOST_PLATFORM \
		--prefix=$TERMUX_PREFIX \
		--with-sysroot=$TERMUX_PREFIX \
		--disable-audio-backends \
		--enable-minify=properties \
		--enable-mobile-optimize \
		--enable-jemalloc \
		--enable-system-pixman \
		--without-wasm-sandboxed-libraries \
		--with-branding=browser/branding/aurora \
		--disable-sandbox \
		--disable-tests \
		--disable-accessibility \
		--disable-crashreporter \
		--disable-dbus \
		--disable-necko-wifi \
		--disable-updater \
		--disable-hardening \
		--disable-parental-controls \
		--disable-printing \
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
