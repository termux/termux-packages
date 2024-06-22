TERMUX_PKG_HOMEPAGE=https://www.thunderbird.net
TERMUX_PKG_DESCRIPTION="Unofficial Thunderbird email client"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=115.6.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp.mozilla.org/pub/thunderbird/releases/${TERMUX_PKG_VERSION}/source/thunderbird-${TERMUX_PKG_VERSION}.source.tar.xz
TERMUX_PKG_SHA256=638beb0d2907c6adbe441b7cd371f205728ac65489c04cb29bb40e71ea2846e3
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libandroid-shmem, libandroid-spawn, libc++, libcairo, libevent, libffi, libice, libicu, libjpeg-turbo, libnspr, libnss, libotr, libpixman, libsm, libvpx, libwebp, libx11, libxcb, libxcomposite, libxdamage, libxext, libxfixes, libxrandr, libxtst, pango, pulseaudio, zlib"
TERMUX_PKG_BUILD_DEPENDS="binutils-cross, libcpufeatures, libice, libsm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local f="media/ffvpx/config_unix_aarch64.h"
	echo "Applying sed substitution to ${f}"
	sed -i -E '/^#define (CONFIG_LINUX_PERF|HAVE_SYSCTL) /s/1$/0/' ${f}
}

termux_step_pre_configure() {
	termux_setup_nodejs
	termux_setup_rust

	# Out of memory when building gkrust
	if [ "$TERMUX_DEBUG_BUILD" = false ]; then
		case "${TERMUX_ARCH}" in
		aarch64|arm|i686|x86_64) RUSTFLAGS+=" -C debuginfo=1" ;;
		esac
	fi

	cargo install cbindgen

	sed \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|" \
		-i "${TERMUX_PKG_SRCDIR}"/build/moz.configure/rust.configure

	export HOST_CC=$(command -v clang)
	export HOST_CXX=$(command -v clang++)

	# https://reviews.llvm.org/D141184
	CXXFLAGS+=" -U__ANDROID__ -D_LIBCPP_HAS_NO_C11_ALIGNED_ALLOC"
	LDFLAGS+=" -landroid-shmem -landroid-spawn -llog"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		termux_setup_no_integrated_as
		# For symbol android_getCpuFeatures
		LDFLAGS+=" -l:libndk_compat.a"
	fi
}

termux_step_configure() {
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

	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" "${TERMUX_PKG_BUILDER_DIR}/thunderbird.desktop"
}
