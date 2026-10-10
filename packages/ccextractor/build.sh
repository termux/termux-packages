TERMUX_PKG_HOMEPAGE=https://ccextractor.org/
TERMUX_PKG_DESCRIPTION="A tool used to produce subtitles for TV recordings"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.96.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/CCExtractor/ccextractor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d2bda9d2071ccf7a81a43c10e82ec00899b2a25b391c300e965274f92ad46208
TERMUX_PKG_DEPENDS="freetype, gpac, libiconv, libmd, libpng, libprotobuf-c, utf8proc"
TERMUX_PKG_BUILD_DEPENDS="zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_get_source() {
	rm -rf src/thirdparty
	touch src/lib_ccx/config.h
}

termux_step_pre_configure() {
	termux_setup_rust
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRust_CARGO_TARGET=$CARGO_TARGET_NAME"

	TERMUX_PKG_SRCDIR+="/src"

	CPPFLAGS+=" -D__USE_GNU"
	CFLAGS+=" -fcommon"
	LDFLAGS+=" -liconv"
	export BINDGEN_EXTRA_CLANG_ARGS="--target=${TERMUX_HOST_PLATFORM}${TERMUX_PKG_API_LEVEL} --sysroot=${TERMUX_STANDALONE_TOOLCHAIN}/sysroot -I$TERMUX_PREFIX/include"
}
