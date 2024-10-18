TERMUX_PKG_HOMEPAGE=https://www.colm.net/open-source/ragel/
TERMUX_PKG_DESCRIPTION="Compiles finite state machines from regular languages into executable C, C++, Objective-C, or D code"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.0.4
TERMUX_PKG_SRCURL=https://www.colm.net/files/ragel/ragel-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=84b1493efe967e85070c69e78b04dc55edc5c5718f9d6b77929762cb2abed278
TERMUX_PKG_DEPENDS="colm, libc++"
TERMUX_PKG_BUILD_DEPENDS="colm-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-colm=$TERMUX_PREFIX
--disable-manual
"

termux_step_host_build() {
	local COLM_BUILD_SH=$TERMUX_SCRIPTDIR/packages/colm/build.sh
	local COLM_SRCURL=$(. $COLM_BUILD_SH; echo $TERMUX_PKG_SRCURL)
	local COLM_SHA256=$(. $COLM_BUILD_SH; echo $TERMUX_PKG_SHA256)
	local COLM_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $COLM_SRCURL)
	termux_download $COLM_SRCURL $COLM_TARFILE $COLM_SHA256
	tar xf $COLM_TARFILE --strip-components=1
	rm -f src/config.h src/defs.h
	ln -sf . src/colm
	sed -i '/^SUBDIRS =/s/ test//' Makefile.in
	./configure
	make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_pre_configure() {
	local colm_bin_dir=$TERMUX_PKG_HOSTBUILD_DIR/src
	echo "Applying configure.diff"
	sed "s|@COLM_BIN_DIR@|${colm_bin_dir}|g" \
		$TERMUX_PKG_BUILDER_DIR/configure.diff | patch --silent -p1
	local libgcc=$($CC -print-libgcc-file-name)
	export LIBS="-L$(dirname ${libgcc}) -l:$(basename ${libgcc})"
}
