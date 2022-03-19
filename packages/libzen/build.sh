TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="ZenLib C++ utility library"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="../../../License.txt"
TERMUX_PKG_MAINTAINER="@termux"
_SOVERSION=0
TERMUX_PKG_VERSION=${_SOVERSION}.4.39
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/libzen/${TERMUX_PKG_VERSION}/libzen_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bbf877062227828ccca63d36af04a16789f3f1013e0c99f6dfd908bf5f2dbe43
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support, libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}" || return
	./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

termux_step_post_make_install() {
	ln -sf libzen.so "${TERMUX_PREFIX}/lib/libzen.so.${_SOVERSION}"
	ln -sf libzen.so "${TERMUX_PREFIX}/lib/libzen.so.${TERMUX_PKG_VERSION}"
}
