TERMUX_PKG_HOMEPAGE=https://sarnold.github.io/cccc/
TERMUX_PKG_DESCRIPTION="Source code counter and metrics tool for C++, C, and Java"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sarnold/cccc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2363948661a9ce6a8383f0f1f9e38548f9e19d31d7c31383e4a79925a868d14d
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
