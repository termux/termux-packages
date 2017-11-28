TERMUX_PKG_HOMEPAGE=http://www.softsynth.com/pforth/
TERMUX_PKG_DESCRIPTION="Portable Forth in C"
_COMMIT=f1994bf609c5b053c5c0d7db2062b570fa9f5ead
TERMUX_PKG_VERSION=20170116
TERMUX_PKG_SRCURL=https://github.com/philburk/pforth/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=fffd7aec1f6601c48a9e2baa284c82d4b22a77f5860a49d83bd811ca4ea18a05
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_REVISION=1

termux_step_post_configure () {
	# Avoid caching the host build as it differs between arches
	# and is quite fast here anyway:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_host_build () {
	local M32=""
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		M32="-m32"
	fi
	cp -Rf $TERMUX_PKG_SRCDIR/* .
	cd build/unix
	CC="gcc $M32" make pfdicdat.h
	CC="gcc $M32" make all
}

termux_step_pre_configure () {
	for file in pfdicdat.h pforth; do
		cp $TERMUX_PKG_HOSTBUILD_DIR/build/unix/$file $TERMUX_PKG_SRCDIR/build/unix/$file
		touch -d "next hour" $TERMUX_PKG_SRCDIR/build/unix/$file
	done

	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build/unix
	export CC="$CC $CFLAGS"
}
termux_step_make_install () {
	cp $TERMUX_PKG_BUILDDIR/pforth_standalone $TERMUX_PREFIX/bin/pforth
}
