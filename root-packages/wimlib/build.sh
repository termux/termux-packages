TERMUX_PKG_HOMEPAGE=https://wimlib.net/
TERMUX_PKG_DESCRIPTION="A library and command-line tools to create, extract, and modify Windows Imaging (WIM ) files"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="1.14.5"

TERMUX_PKG_SRCURL="https://github.com/ebiggers/wimlib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5f9416b3750c29d6ad35a2fc3bd6697807566ee287b28e004b0111c3787b1ce2

TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-utimes, libfuse3, liblzma, libxml2, ntfs-3g, openssl, zlib"

TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
ac_cv_lib_rt_mq_open=yes
"
termux_step_pre_configure() {
	autoreconf -fi
	LDFLAGS+=" -landroid-glob -landroid-utimes"
}
