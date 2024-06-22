TERMUX_PKG_HOMEPAGE=https://www.colm.net/open-source/colm/
TERMUX_PKG_DESCRIPTION="COmputer Language Machinery"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.14.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.colm.net/files/colm/colm-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6037b31c358dda6f580f7321f97a182144a8401c690b458fcae055c65501977d
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	rm -f src/config.h src/defs.h
	ln -sf . src/colm
}

termux_step_host_build() {
	local srcdir=$TERMUX_PKG_SRCDIR
	${srcdir}/configure
	local f
	for f in ${srcdir}/src/*.lm; do
		ln -sf ${f} src/$(basename ${f})
	done
	make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/src:$PATH

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
