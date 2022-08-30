TERMUX_PKG_HOMEPAGE=https://motif.ics.com/
TERMUX_PKG_DESCRIPTION="Motif is a freely available source code distribution for the Motif user interface component toolkit."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.8
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/motif/motif-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libjpeg-turbo, libpng, libxft, libx11, libxmu"
TERMUX_PKG_BUILD_DEPENDS="flex, xbitmaps, xorgproto"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes ac_cv_func_memcmp_working=yes ac_cv_func_memcmp=yes"

termux_step_post_get_source() {
	touch NEWS AUTHORS
	#sed "0,/%{/{s/%{/%option main{/}" -i tools/wml/wmluiltok.l
	sed "s/test\ \-f/[\ \-e /g;s/||/\ ]\ ||/g;s/\$(LN_S)/\$(LN_S)\ \-f/g" -i lib/Xm/Makefile.am
	autoreconf -if
}

termux_step_host_build() {
	"${TERMUX_PKG_SRCDIR}/configure"
        sed -i 's/ -shared / -Wl,-O1,--as-needed\0/g' $TERMUX_PKG_HOSTBUILD_DIR/libtool
	make -j $TERMUX_MAKE_PROCESSES -C config
	#CFLAGS+=" -ffat-lto-objects"
	#LDFLAGS+=" -lfl"
	make -j $TERMUX_MAKE_PROCESSES -C lib/Xm
	make -j $TERMUX_MAKE_PROCESSES -C tools/wml
}

termux_step_post_configure() {
	cp -r $TERMUX_PKG_HOSTBUILD_DIR/config $TERMUX_PKG_BUILDDIR
	cp -r $TERMUX_PKG_HOSTBUILD_DIR/tools/wml $TERMUX_PKG_BUILDDIR/tools
	sed "s/(\ cd\ \$(top_builddir)\/config\/util/#(\ cd\ \$(top_builddir)\/config\/util/g" -i $TERMUX_PKG_BUILDDIR/lib/Xm/Makefile
	sed -i 's/ -shared / -Wl,-O1,--as-needed\0/g' $TERMUX_PKG_BUILDDIR/libtool
	sed -i "s/motif.wmd: wmldbcreate/motif.wmd: /g" $TERMUX_PKG_BUILDDIR/tools/wml/Makefile
}
