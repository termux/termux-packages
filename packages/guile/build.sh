TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/guile/
TERMUX_PKG_DESCRIPTION="GNU extension language and Scheme interpreter"
TERMUX_PKG_VERSION=2.0.14
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/guile/guile-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libgmp, libunistring, libffi, libgc, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_type_complex_double=no  ac_cv_search_clock_getcpuclockid=false"
TERMUX_PKG_SHA256=8aeb2f353881282fe01694cce76bb72f7ffdd296a12c7a1a39255c27b0dfe5f1
TERMUX_PKG_HOSTBUILD=yes 
termux_step_host_build () {
	mkdir HOSTBUILDINSTALL
	../src/configure --prefix=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL
	make -j $TERMUX_MAKE_PROCESSES
	make install 
}
termux_step_pre_configure() {
	CFLAGS=${CFLAGS/Oz/Os}
	export GUILE_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL/bin/guile
	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL/lib
}
