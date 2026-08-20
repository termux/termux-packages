TERMUX_PKG_HOMEPAGE=https://github.com/d99kris/nchat
TERMUX_PKG_DESCRIPTION="TUI for Telegram and WhatsApp"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.17.26
TERMUX_PKG_SRCURL="https://github.com/d99kris/nchat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0c8730052d1c4ca2b41102eb433bdae8643b0e261a6dbaab8c0aca9f2971465e
TERMUX_PKG_DEPENDS="file, libandroid-glob, libandroid-wordexp, libpng, libsqlite, ncurses, openssl, zlib"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DHAS_TELEGRAM=on
-DHAS_WHATSAPP=on
-DHAS_STATICGOLIB=off
-DCMAKE_INSTALL_MANDIR=${TERMUX_PREFIX}/share/man
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
"
# signal part does not work: nchat gives a warning that libsignal only
# supports x86 offically and segfaults after a signal profile has been
# setup
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-DHAS_SIGNAL=off"

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
}
