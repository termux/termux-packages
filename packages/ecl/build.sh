TERMUX_PKG_HOMEPAGE=https://common-lisp.net/project/ecl/
TERMUX_PKG_DESCRIPTION="ECL (Embeddable Common Lisp) is an interpreter of the Common Lisp language."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="21.2.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://common-lisp.net/project/ecl/static/files/release/ecl-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=b15a75dcf84b8f62e68720ccab1393f9611c078fcd3afdd639a1086cad010900
TERMUX_PKG_DEPENDS="libandroid-support, libgmp, libgc, libffi"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BLACKLISTED_ARCHES="i686, x86_64"
TERMUX_PKG_HAS_DEBUG=false

# See https://gitlab.com/embeddable-common-lisp/ecl/-/blob/develop/INSTALL
# for upstream cross build guide.

# ECL needs itself during build, so we need to build it for the host first.
termux_step_host_build() {
	srcdir=$TERMUX_PKG_SRCDIR/src
	hostprefix=$TERMUX_PKG_HOSTBUILD_DIR/prefix
	mkdir $hostprefix
	autoreconf -fi $srcdir/gmp
	$srcdir/configure ABI=${TERMUX_ARCH_BITS} \
		CFLAGS=-m${TERMUX_ARCH_BITS} LDFLAGS=-m${TERMUX_ARCH_BITS} \
		--prefix=$hostprefix --srcdir=$srcdir --disable-c99complex
	make
	make install
}

termux_step_pre_configure() {
	srcdir=$TERMUX_PKG_SRCDIR/src
	autoreconf -fi $srcdir
}

termux_step_configure() {
	# Copy cross_config for target architecture.
	case $TERMUX_ARCH in
		aarch64) crossconfig=android-arm64 ;;
		arm)     crossconfig=android-arm ;;
		*)       termux_error_exit "Unsupported arch: $TERMUX_ARCH" ;;
	esac
	crossconfig="$TERMUX_PKG_SRCDIR/src/util/$crossconfig.cross_config"
	export ECL_TO_RUN=$TERMUX_PKG_HOSTBUILD_DIR/prefix/bin/ecl

	srcdir=$TERMUX_PKG_SRCDIR/src
	$srcdir/configure \
		--srcdir=$srcdir \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		--build=$TERMUX_BUILD_TUPLE \
		--with-cross-config=$crossconfig \
		--disable-c99complex \
		--enable-gmp=system \
		--enable-boehm=system
}
