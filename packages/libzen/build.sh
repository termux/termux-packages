TERMUX_PKG_HOMEPAGE=https://mediaarea.net/en/MediaInfo
TERMUX_PKG_DESCRIPTION="ZenLib C++ utility library"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="../../../License.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.41
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mediaarea.net/download/source/libzen/${TERMUX_PKG_VERSION}/libzen_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aad6c25bffcc695828e4d36700243a19a0d9503fbe57d38a2fbfa302fb34df2f
TERMUX_PKG_DEPENDS="libandroid-support, libc++"
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-shared --enable-static"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/Project/GNU/Library"
	TERMUX_PKG_BUILDDIR="${TERMUX_PKG_SRCDIR}"
	cd "${TERMUX_PKG_SRCDIR}" || return
	./autogen.sh

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
