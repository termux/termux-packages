TERMUX_PKG_HOMEPAGE=https://www.mercurylang.org/
TERMUX_PKG_DESCRIPTION="A logic/functional programming language"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.01.4
TERMUX_PKG_SRCURL=https://dl.mercurylang.org/release/mercury-srcdist-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7755a03142002f4a31a73effcca3c9592bba25da38a479789ff45e9cc99353ed
TERMUX_PKG_DEPENDS="libandroid-sysv-semaphore-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-csharp-grade
--disable-java-grade
--disable-debug-grades
--disable-par-grades
--disable-prof-grades
--disable-trail-grades
mercury_cv_sigaction_field=sa_sigaction
mercury_cv_sigcontext_struct_2arg=no
mercury_cv_sigcontext_struct_3arg=no
mercury_cv_pc_access=no
mercury_cv_siginfo_t=yes
mercury_cv_is_bigender=no
mercury_cv_is_littleender=yes
mercury_cv_can_do_pending_io=yes
mercury_cv_gcc_labels=yes
mercury_cv_asm_labels=yes
mercury_cv_gcc_model_fast=no
mercury_cv_gcc_model_reg=no
mercury_cv_cannot_use_structure_assignment=no
"
TERMUX_PKG_EXTRA_MAKE_ARGS="THREAD_LIBS="

termux_step_host_build() {
	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;
	./configure \
		CC="gcc -m${TERMUX_ARCH_BITS}" CXX="g++ -m${TERMUX_ARCH_BITS}" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
	_BUILD_UTIL=$TERMUX_PKG_HOSTBUILD_DIR/util
	_BUILD_COMPILER=$TERMUX_PKG_HOSTBUILD_DIR/compiler
	export MERCURY_MKINIT=$_BUILD_UTIL/mkinit
	export MERCURY_DEMANGLER=$_BUILD_UTIL/mdemangle
	export MERCURY_COMPILER=$_BUILD_COMPILER/mercury_compile
	export MERCURY_ALL_LOCAL_C_INCL_DIRS=-I$TERMUX_PREFIX/include

	mkdir -p _bin
	ln -sf $MERCURY_MKINIT _bin/
	PATH=$TERMUX_PKG_BUILDDIR/_bin:$PATH

	find "$TERMUX_PKG_SRCDIR" -name '*.c' -o -name '*.m' | \
		xargs -n 1 sed -i \
		-e 's:"/tmp:"'$TERMUX_PREFIX'/tmp:g' \
		-e 's:"/var/tmp:"'$TERMUX_PREFIX'/tmp:g'
}

termux_step_post_configure() {
	sed -i -e 's:^\(LINKER_POST_FLAGS=.*\)"$:\1 '"$TERMUX_PREFIX"'/lib/libandroid-sysv-semaphore.a":g' \
		$TERMUX_PKG_SRCDIR/scripts/ml

	sed -i -e 's,\([^A-Za-z0-9_]PATH=\)\.\.,\1'$_BUILD_UTIL':..,g' \
		$TERMUX_PKG_SRCDIR/Mmakefile
}
