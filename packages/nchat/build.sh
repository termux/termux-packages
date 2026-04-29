TERMUX_PKG_HOMEPAGE=https://github.com/d99kris/nchat
TERMUX_PKG_DESCRIPTION="TUI for Telegram, WhatsApp and Signal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# libsignal version can be found at:
# https://github.com/d99kris/nchat/blob/v${TERMUX_PKG_VERSION[0]}/lib/sgchat/go/ext/signal/pkg/libsignalgo/version.go
TERMUX_PKG_VERSION=(5.14.44
                    0.87.5)
TERMUX_PKG_SRCURL=("https://github.com/d99kris/nchat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
                   "https://github.com/signalapp/libsignal/archive/refs/tags/v${TERMUX_PKG_VERSION[1]}.tar.gz")
TERMUX_PKG_SHA256=(e1d32c9130d94caadfcf08e69a6edd23f42c1be182479a920a73dfe546bc885c
                   3f193053a632f3e15df97a2e67581f1906525bf5e79e183a2d96a88fb86e6769)
TERMUX_PKG_DEPENDS="file, libandroid-glob, libandroid-wordexp, libpng, libsqlite, ncurses, openssl, zlib"
# Cannot autoupdate as we should make sure libsignal version is the one nchat expects
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAS_TELEGRAM=on
-DHAS_WHATSAPP=on
-DHAS_SIGNAL=on
-DHAS_STATICGOLIB=off
-DCMAKE_INSTALL_MANDIR=${TERMUX_PREFIX}/share/man
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
"

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_golang

	cmake -DHAS_SIGNAL=off -DHAS_TELEGRAM=on -DHAS_WHATSAPP=on \
		"$TERMUX_PKG_SRCDIR"

	make generate_mime_types_gperf generate_mtproto tl-parser generate_common
}

termux_step_pre_configure() {
	termux_setup_golang
	termux_setup_rust
	termux_setup_protobuf
	termux_setup_cmake

	export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/bin:${PATH}"

	# boringssl crate refuses to build without ANDROID_NDK_HOME:
	export ANDROID_NDK_HOME="${NDK}"

	mkdir -p $TERMUX_PKG_BUILDDIR/lib/sgchat/go/libsignal
	mv $TERMUX_PKG_SRCDIR/libsignal-${TERMUX_PKG_VERSION[1]} \
		$TERMUX_PKG_BUILDDIR/lib/sgchat/go/libsignal/libsignal-src

	cd $TERMUX_PKG_BUILDDIR/lib/sgchat/go/libsignal/libsignal-src
	cargo build \
		-p libsignal-ffi \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release

	install -Dm600 target/"$TERMUX_HOST_PLATFORM"/release/libsignal_ffi.a \
		"$TERMUX_PKG_BUILDDIR"/lib/sgchat/go/libsignal/
	echo "v${TERMUX_PKG_VERSION[1]}" > "$TERMUX_PKG_BUILDDIR"/lib/sgchat/go/libsignal/libsignal_ffi.version
}
