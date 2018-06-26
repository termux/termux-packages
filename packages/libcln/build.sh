TERMUX_PKG_HOMEPAGE=https://www.ginac.de/CLN/
TERMUX_PKG_DESCRIPTION="CLN is a library for efficient computations with all kinds of numbers in arbitrary precision"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://www.ginac.de/CLN/cln-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2d99d7c433fb60db1e28299298a98354339bdc120d31bb9a862cafc5210ab748
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-gnu-ld=no"
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	if [ $TERMUX_ARCH = arm ]; then
		# See the following section in INSTALL:
		# "(*) On these platforms, problems with the assembler routines have been
		# reported. It may be best to add "-DNO_ASM" to CPPFLAGS before configuring."
		CPPFLAGS+=" -DNO_ASM"
		CXXFLAGS+=" -fintegrated-as"
	fi

	sed -i -e 's%tests/Makefile %%' configure.ac
	sed -i -e 's%examples/Makefile %%' configure.ac
	sed -i -e 's%benchmarks/Makefile %%' configure.ac

	autoreconf
}

termux_step_post_configure() {
	cd $TERMUX_PKG_SRCDIR
	sed -i -e 's% tests%%' Makefile
	sed -i -e 's% examples%%' Makefile
	sed -i -e 's% benchmarks%%' Makefile
}
