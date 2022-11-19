TERMUX_PKG_HOMEPAGE=https://sarnold.github.io/cccc/
TERMUX_PKG_DESCRIPTION="Source code counter and metrics tool for C++, C, and Java"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_SRCURL=https://github.com/sarnold/cccc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c03b29d45f1acb6f669b6d6d193dcdf5603f8c2758f0fb4bc1eeacef92ecb78a
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="cccc"
TERMUX_PKG_HOSTBUILD=true
TERMUX_MAKE_PROCESSES=1

termux_step_host_build() {
	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;

	export CC="gcc -m${TERMUX_ARCH_BITS}"
	export CCC="g++ -m${TERMUX_ARCH_BITS}"

	sh build_posixgcc.sh
}

termux_step_pre_configure() {
	export CCC="$CXX"
	CFLAGS+=" $CPPFLAGS"
	TERMUX_PKG_EXTRA_MAKE_ARGS+="
		ANTLR=$TERMUX_PKG_HOSTBUILD_DIR/pccts/bin/antlr
		DLG=$TERMUX_PKG_HOSTBUILD_DIR/pccts/bin/dlg
		"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin cccc/cccc
}
