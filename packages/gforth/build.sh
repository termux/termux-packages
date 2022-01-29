TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gforth/
TERMUX_PKG_DESCRIPTION="The Forth implementation of the GNU project"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.3
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/gforth/gforth-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_file___arch_386_asm_fs=yes
ac_cv_file___arch_386_disasm_fs=yes
ac_cv_file___arch_amd64_asm_fs=yes
ac_cv_file___arch_amd64_disasm_fs=yes
ac_cv_file___arch_arm_asm_fs=no
ac_cv_file___arch_arm_disasm_fs=no
ac_cv_file___arch_generic_asm_fs=no
ac_cv_file___arch_generic_disasm_fs=no
ac_cv_func_memcmp_working=yes
skipcode=no
--without-check
"
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	_PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;
	./configure --prefix=$_PREFIX_FOR_BUILD CC="gcc -m$TERMUX_ARCH_BITS"
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	PATH=$_PREFIX_FOR_BUILD/bin:$PATH
}

termux_step_post_configure() {
	sed -i -e 's:\.\(/gforth-ditc\):'$TERMUX_PKG_HOSTBUILD_DIR'\1:g' \
		Makefile
}
