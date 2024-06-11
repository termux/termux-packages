TERMUX_PKG_HOMEPAGE="https://maxima.sourceforge.io/"
TERMUX_PKG_DESCRIPTION="A Computer Algebra System"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=()
TERMUX_PKG_VERSION+=(5.47.0)
TERMUX_PKG_VERSION+=(24.5.10) # ECL version
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=(https://downloads.sourceforge.net/sourceforge/maxima/Maxima-source/$TERMUX_PKG_VERSION-source/maxima-$TERMUX_PKG_VERSION.tar.gz
                   https://common-lisp.net/project/ecl/static/files/release/ecl-${TERMUX_PKG_VERSION[1]}.tgz)
TERMUX_PKG_SHA256=(9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a
                   e4ea65bb1861e0e495386bfa8bc673bd014e96d3cf9d91e9038f91435cbe622b)
TERMUX_PKG_DEPENDS="ecl"
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"
TERMUX_PKG_BUILD_IN_SRC="true"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-ecl"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	mv ecl-${TERMUX_PKG_VERSION[1]} ecl
}

termux_step_host_build() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir -p $_PREFIX_FOR_BUILD

	mkdir ecl
	pushd ecl
	local ecl_srcdir=$TERMUX_PKG_SRCDIR/ecl/src
	autoreconf -fi $ecl_srcdir/gmp
	$ecl_srcdir/configure ABI=${TERMUX_ARCH_BITS} \
		CFLAGS=-m${TERMUX_ARCH_BITS} LDFLAGS=-m${TERMUX_ARCH_BITS} \
		--prefix=$_PREFIX_FOR_BUILD --srcdir=$ecl_srcdir --disable-c99complex
	make -j $TERMUX_PKG_MAKE_PROCESSES
	make install
	popd

	PATH=$_PREFIX_FOR_BUILD/bin:$PATH

	mkdir maxima
	pushd maxima
	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 ! -name ecl -exec cp -a \{\} ./ \;
	./configure --prefix=$_PREFIX_FOR_BUILD $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make -j $TERMUX_PKG_MAKE_PROCESSES
	popd
}

termux_step_make() {
	local _PREFIX_FOR_BUILD=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	
	cat > $_PREFIX_FOR_BUILD/bin/gcc <<-EOF
		#!/bin/sh
		exec \$CC \$CFLAGS \$CPPFLAGS \$LDFLAGS "\$@" -Wno-unused-command-line-argument
	EOF
	chmod 0700 $_PREFIX_FOR_BUILD/bin/gcc
	local loop_max=1000
	local f
	local i=0
	while [ ! -e src/binary-ecl/maxima ]; do
		make -C src
		for f in $(find src/binary-ecl -type f -name '*.fas'); do
			cp $TERMUX_PKG_HOSTBUILD_DIR/maxima/$f $f
		done
		i=$(( $i + 1 ))
		if [ $i -gt $loop_max ]; then
			return 1
		fi
	done
	make
	rm -f $_PREFIX_FOR_BUILD/bin/gcc
}
