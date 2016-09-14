TERMUX_PKG_HOMEPAGE=http://www.softsynth.com/pforth/
TERMUX_PKG_DESCRIPTION="Portable Forth in C"
_COMMIT=706b5e4b7faffb3fb4c58651be5df3e4bd2be794
TERMUX_PKG_VERSION=20160530
TERMUX_PKG_SRCURL=https://github.com/philburk/pforth/archive/${_COMMIT}.zip
TERMUX_PKG_FOLDERNAME=pforth-${_COMMIT}
TERMUX_PKG_HOSTBUILD=yes

termux_step_host_build () {
	cp -Rf $TERMUX_PKG_SRCDIR/* .
	cd build/unix
	CC=gcc make pfdicdat.h
	CC=gcc make all
}

termux_step_pre_configure () {
	for file in pfdicdat.h pforth; do
		cp $TERMUX_PKG_HOSTBUILD_DIR/build/unix/$file $TERMUX_PKG_SRCDIR/build/unix/$file
		$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_SRCDIR/build/unix/$file
	done

	export TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/build/unix
	export CC="$CC $CFLAGS"
}
termux_step_make_install () {
	cp $TERMUX_PKG_BUILDDIR/pforth_standalone $TERMUX_PREFIX/bin/pforth
}
