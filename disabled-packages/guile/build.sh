TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/guile/
TERMUX_PKG_DESCRIPTION="Portable, embeddable Scheme implementation written in C"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.2.6
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/guile/guile-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=08c0e7487777740b61cdd97949b69e8a5e2997d8c2fe6c7e175819eb18444506
TERMUX_PKG_DEPENDS="libandroid-support, libffi, libgc, libgmp, libltdl, libunistring"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BREAKS="guile-dev"
TERMUX_PKG_REPLACES="guile-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_type_complex_double=no ac_cv_search_clock_getcpuclockid=false ac_cv_func_GC_move_disappearing_link=yes ac_cv_func_GC_is_heap_ptr=yes"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	mkdir HOSTBUILDINSTALL

	../src/configure --prefix=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL # CFLAGS="-m32" LDFLAGS=" -L/usr/lib/i386-linux-gnu" --host=i386-linux-gnu
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {

	export GUILE_FOR_BUILD="$TERMUX_PKG_HOSTBUILD_DIR"/HOSTBUILDINSTALL/bin/guile
	export LD_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR"/HOSTBUILDINSTALL/lib
}

termux_step_post_massage() {
        sed -i 's',"$TERMUX_STANDALONE_TOOLCHAIN/bin/$TERMUX_HOST_PLATFORM-pkg-config","$TERMUX_PREFIX/bin/pkg-config",'g' $TERMUX_PKG_MASSAGEDIR$TERMUX_PREFIX/bin/guile-config
}                              
