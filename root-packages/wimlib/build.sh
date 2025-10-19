TERMUX_PKG_HOMEPAGE=https://wimlib.net/
TERMUX_PKG_DESCRIPTION="A library to create, extract, and modify Windows Imaging (WIM) files with FUSE support"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="1.14.4"
TERMUX_PKG_SRCURL="https://github.com/xingguangcuican6666/wimlib-termux/archive/refs/tags/v${TERMUX_PKG_VERSION}-termux.zip"
TERMUX_PKG_SHA256=7a26253c57fb688c3acd37159c220507734b49323116182540cc3cf3ec99cfed
TERMUX_PKG_DEPENDS="gettext, build-essential, pkg-config, liblzma, libandroid-support, libfuse3, libxml2, ntfs-3g, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
termux_step_pre_configure() {
    cd "$TERMUX_PKG_SRCDIR"
	echo "ac_cv_lib_rt_mq_open=yes" > config.cache
	autoreconf -if
}
termux_step_configure() {
    cd "$TERMUX_PKG_SRCDIR"
    ./configure \
		--prefix=$TERMUX_PREFIX \
		--disable-static \
		--enable-shared \
		ac_cv_lib_rt_mq_open=yes \
		LIBS="-lrt" \
		LDFLAGS="-Wl,--no-as-needed"
}
# 配置步骤
termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"
	make -j8
	
}
termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	make install
}