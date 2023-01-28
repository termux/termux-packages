TERMUX_PKG_HOMEPAGE=https://git.linuxtv.org/v4l-utils.git
TERMUX_PKG_DESCRIPTION="Linux utilities to handle media devices"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.22.1
TERMUX_PKG_SRCURL=https://linuxtv.org/downloads/v4l-utils/v4l-utils-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=65c6fbe830a44ca105c443b027182c1b2c9053a91d1e72ad849dfab388b94e31
TERMUX_PKG_DEPENDS="argp, libc++, libv4l"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--disable-libdvbv5
--disable-qv4l2
--disable-qvidcap
--disable-bpf
--without-jpeg
--without-libudev
"

termux_step_pre_configure() {
	local _inc="$TERMUX_PKG_SRCDIR/_getsubopt/include"
	rm -rf "${_inc}"
	mkdir -p "${_inc}"
	cp "$TERMUX_PKG_BUILDER_DIR/getsubopt.h" "${_inc}"

	CPPFLAGS+=" -I${_inc} -D__force= -UANDROID"

	local _lib="$TERMUX_PKG_BUILDDIR/_getsubopt/lib"
	rm -rf "${_lib}"
	mkdir -p "${_lib}"
	pushd "${_lib}"/..
	$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_BUILDER_DIR/getsubopt.c" \
		-fvisibility=hidden -c -o ./getsubopt.o
	$AR cru "${_lib}"/libgetsubopt.a ./getsubopt.o
	popd

	LDFLAGS+=" -L${_lib} -l:libgetsubopt.a"

	local f
	for f in $(find . -name Makefile.in); do
		sed -i -E 's/ -lpthread($| )/ /g' ${f}
		sed -i -E 's/ -lrt($| )/ /g' ${f}
	done
}

termux_step_make_install() {
	make -C utils install
	make -C contrib install
	install -Dm600 -t $TERMUX_PREFIX/etc/rc_keymaps \
		$TERMUX_PKG_SRCDIR/utils/keytable/rc_keymaps/*
}
