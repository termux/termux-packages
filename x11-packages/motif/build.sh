TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/motif/
TERMUX_PKG_DESCRIPTION="Motif widget toolkit"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.8
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/motif/Motif%20${TERMUX_PKG_VERSION}%20Source%20Code/motif-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7
TERMUX_PKG_DEPENDS="fontconfig, freetype, libandroid-support, libice, libiconv, libjpeg-turbo, libpng, libsm, libx11, libxext, libxft, libxmu, libxt"
TERMUX_PKG_BUILD_DEPENDS="flex, xbitmaps, xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file__usr_X_include_X11_X_h=no
ac_cv_file__usr_X11R6_include_X11_X_h=no
ac_cv_func_setpgrp_void=yes
"
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	rm -f tools/wml/{wmllex,wmluiltok}.c
}

termux_step_host_build() {
	"$TERMUX_PKG_SRCDIR/configure" ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}

	make -C config/util makestrs
	make -C lib/Xm
	make -C tools/wml wmluiltok LIBS=-lfl
	make -C tools/wml
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/config/util:$TERMUX_PKG_HOSTBUILD_DIR/tools/wml:$PATH
}

termux_step_post_configure() {
	make -C tools/wml wmluiltok LIBS=-lfl
}
