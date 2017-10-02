TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/guile/
TERMUX_PKG_DESCRIPTION="GNU extension language and Scheme interpreter"
TERMUX_PKG_VERSION=2.2.2
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/guile/guile-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libgmp, libunistring, libffi, libgc, libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_type_complex_double=no  ac_cv_search_clock_getcpuclockid=false"
TERMUX_PKG_SHA256=3d9b94183b19f04dd4317da87beedafd1c947142f3d861ca1f0224e7a75127ee
TERMUX_PKG_HOSTBUILD=yes 
TERMUX_PKG_CONFLICTS="guile"
termux_step_host_build () {

	mkdir HOSTBUILDINSTALL
	# cross compiling elisp from 64 bit guile to 32 bit for i686 and arm doesn't work (for me?) properly so we are using a precompiled boot.go.
	# this is not an issue because its reproducible. All 32 bit boot.go are bit identitical.
	# to actually derive 32 boot.go ourselves requires 32bit host-build guile and to get that to work you also need to patch 32 bit libgc so it works
	# under docker (until libgc 7.7 is released anyway). This is really annoying and unnecessary.  
		../src/configure --prefix=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL # CFLAGS="-m32" LDFLAGS=" -L/usr/lib/i386-linux-gnu" --host=i386-linux-gnu
	make -j $TERMUX_MAKE_PROCESSES
	make install 
	

}
termux_step_pre_configure() {
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		mkdir -p $TERMUX_PREFIX/share/guile/2.2/language/elisp
		cp module/language/elisp/boot.el  $TERMUX_PREFIX/share/guile/2.2/language/elisp/
		cp $TERMUX_PKG_BUILDER_DIR/boot.go $TERMUX_PREFIX/lib/guile/2.2/ccache/language/elisp/
	fi

	CFLAGS=${CFLAGS/Oz/Os}
	export GUILE_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL/bin/guile
	export LD_LIBRARY_PATH=$TERMUX_PKG_HOSTBUILD_DIR/HOSTBUILDINSTALL/lib
}

