TERMUX_PKG_HOMEPAGE=https://www.mozilla.org/firefox
TERMUX_PKG_DESCRIPTION="Mozilla Firefox web browser"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=110.0.1
TERMUX_PKG_SRCURL=https://ftp.mozilla.org/pub/firefox/releases/${TERMUX_PKG_VERSION}/source/firefox-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=f19bb74d684b992625abca68f5776198974cd2785eb5d02d51ba007fc998491f
# ffmpeg and pulseaudio are dependencies through dlopen(3):
TERMUX_PKG_DEPENDS="at-spi2-atk, ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-sysv-semaphore, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxi, libxrandr, libxrender, libxtst, pango, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures"
TERMUX_MAKE_PROCESSES=1

termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -i -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' ${f}

	# Add support for FFmpeg 6.0 (please remove when added upstream)
	local _FFMPEG60_DIR=$TERMUX_PKG_SRCDIR/dom/media/platforms/ffmpeg/ffmpeg60
	if [ -d "${_FFMPEG60_DIR}" ]; then
		termux_error_exit "Directory ${_FFMPEG60_DIR} already exists."
	fi
	rm -rf ${_FFMPEG60_DIR}
	mkdir -p ${_FFMPEG60_DIR}
	cd ${_FFMPEG60_DIR}
	cp ../ffmpeg59/moz.build ./
	mkdir -p include
	cd include
	mkdir -p libav{codec,util}
	for f in avcodec.h avfft.h bsf.h codec.h codec_desc.h codec_id.h codec_par.h defs.h packet.h vdpau.h version.h version_major.h; do
		cp $TERMUX_PREFIX/include/libavcodec/${f} ./libavcodec/
	done
	for f in attributes.h avutil.h buffer.h channel_layout.h common.h cpu.h dict.h error.h frame.h hwcontext.h hwcontext_vaapi.h intfloat.h log.h macros.h mathematics.h mem.h pixfmt.h rational.h samplefmt.h version.h avconfig.h; do
		cp $TERMUX_PREFIX/include/libavutil/${f} ./libavutil/
	done
	if [ $TERMUX_ARCH = "i686" ]; then
		sed -i -E '/^#define AV_HAVE_FAST_UNALIGNED /s/0$/1/' \
			./libavutil/avconfig.h
	fi
	local s=$(find . -type f -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "66d7de01c50d46b588021d1b7be87056b95ec295aeb98b3f37adad1ba9154319  "* ]]; then
		termux_error_exit "Checksum mismatch for ffmpeg60 header files."
	fi
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
