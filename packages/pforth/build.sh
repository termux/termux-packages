TERMUX_PKG_HOMEPAGE=http://www.softsynth.com/pforth/
TERMUX_PKG_DESCRIPTION="Portable Forth in C"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=fad6b12e3aa8d52d9ee1f32ab7d2f198f8362173
TERMUX_PKG_VERSION=20210315
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/philburk/pforth/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=d6358c1a3608b12b7438971c10a902046969488680ec3c84222c6aa6b02b4a03
TERMUX_PKG_HOSTBUILD=true

termux_step_post_configure() {
	# Avoid caching the host build as it differs between arches
	# and is quite fast here anyway:
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_host_build() {
	local M32=""
	if [ $TERMUX_ARCH_BITS = "32" ]; then
		M32="-m32"
	fi
	cp -Rf $TERMUX_PKG_SRCDIR/* .
	cd build/unix
	CC="gcc $M32" make pfdicdat.h
	CC="gcc $M32" make all
}

termux_step_pre_configure() {
	for file in pfdicdat.h pforth; do
		cp $TERMUX_PKG_HOSTBUILD_DIR/build/unix/$file $TERMUX_PKG_SRCDIR/build/unix/$file
		touch -d "next hour" $TERMUX_PKG_SRCDIR/build/unix/$file
	done

	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build/unix
	export CC="$CC $CFLAGS $LDFLAGS"
}

termux_step_make_install() {
	cp $TERMUX_PKG_BUILDDIR/pforth_standalone $TERMUX_PREFIX/bin/pforth
}
