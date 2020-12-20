TERMUX_PKG_HOMEPAGE=https://picolisp.com/wiki/?home
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_LICENSE="MIT"
# TERMUX_PKG_SRCDIR is overriden below
TERMUX_PKG_LICENSE_FILE="../COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20.7.24
TERMUX_PKG_REVISION=1
# We use our bintray mirror since old version snapshots are not kept on main site.
TERMUX_PKG_SRCURL=https://dl.bintray.com/termux/upstream/picolisp_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72e8d394ad32a6659210ac2cc4b7bb736dc9b94c6ac8d6296506b6dfdc92f90c
TERMUX_PKG_DEPENDS="libcrypt, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
# arm and i686: The c code uses gcc-specific "variable length array in structure":
# x86_64: The assembly is not position-independent:
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Validate that we have the right version:
	grep -q "Version ${TERMUX_PKG_VERSION//./ }" src64/version.l || {
		termux_error_exit "Picolisp version needs to be bumped"
	}

	if [ $TERMUX_ARCH_BITS = 64 ]; then
		cd $TERMUX_PKG_SRCDIR
		if [ $TERMUX_ARCH = "aarch64" ]; then
			export TERMUX_PKG_EXTRA_MAKE_ARGS=arm64.android
		else
			termux_error_exit "Unsupported arch: $TERMUX_ARCH"
		fi
		TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src64
	else
		TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	fi
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR
	ORIG_CFLAGS="$CFLAGS"
	CFLAGS+=" -c $LDFLAGS $CPPFLAGS"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/

	if [ $TERMUX_ARCH_BITS = "64" ]; then
		$TERMUX_HOST_PLATFORM-as -o ${TERMUX_PKG_EXTRA_MAKE_ARGS}.base.o ${TERMUX_PKG_EXTRA_MAKE_ARGS}.base.s
		$TERMUX_HOST_PLATFORM-as -o ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ext.o ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ext.s
		$TERMUX_HOST_PLATFORM-as -o ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ht.o ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ht.s

		# Use -fuse-ld=bfd to avoid using the gold linker (which Termux
		# patches NDK to use by default) as it causes (tzo), the time
		# zone offset, to always be 0 (and probably other problems):
		$CC -o ../bin/picolisp ${TERMUX_PKG_EXTRA_MAKE_ARGS}.base.o \
			-Wl,--no-as-needed -rdynamic -lc -lm -ldl -pie -fuse-ld=bfd
		chmod +x ../bin/picolisp
		$CC -o ../lib/ext -shared -rdynamic -fuse-ld=bfd ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ext.o
		$CC -o ../lib/ht -shared -rdynamic -fuse-ld=bfd ${TERMUX_PKG_EXTRA_MAKE_ARGS}.ht.o
	fi

	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/

	rm -Rf $TERMUX_PREFIX/lib/picolisp
	mkdir -p $TERMUX_PREFIX/lib/picolisp

	cp -Rf $TERMUX_PKG_SRCDIR/../* $TERMUX_PREFIX/lib/picolisp/
	rm -Rf $TERMUX_PREFIX/lib/picolisp/{src,man,java,ersatz}

	# Replace first line "#!/usr/bin/picolisp /usr/lib/picolisp/lib.l":
	sed -i "1 s|^.*$|#!$TERMUX_PREFIX/bin/picolisp $TERMUX_PREFIX/lib/picolisp/lib.l|g" $TERMUX_PREFIX/lib/picolisp/bin/pil

	( cd $TERMUX_PREFIX/bin && ln -f -s ../lib/picolisp/bin/picolisp picolisp && ln -f -s ../lib/picolisp/bin/pil pil )

	# Bundled tools:
	$CC $ORIG_CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/lib/picolisp/bin/ssl ../src/ssl.c -lssl -lcrypto
	$CC $ORIG_CFLAGS $CPPFLAGS $LDFLAGS -o $TERMUX_PREFIX/lib/picolisp/bin/httpGate ../src/httpGate.c -lssl -lcrypto

	# Man pages:
	cp $TERMUX_PKG_SRCDIR/../man/man1/{pil,picolisp}.1 $TERMUX_PREFIX/share/man/man1/
}
