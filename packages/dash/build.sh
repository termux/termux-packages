TERMUX_PKG_HOMEPAGE=http://gondor.apana.org.au/~herbert/dash/
TERMUX_PKG_DESCRIPTION="Small POSIX-compliant implementation of /bin/sh"
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_VERSION=0.5.10
TERMUX_PKG_SHA256=ad70e0cc3116b424931c392912b3ebdb8053b21f3fd968c782f0b19fd8ae31ab
TERMUX_PKG_SRCURL=http://gondor.apana.org.au/~herbert/dash/files/dash-${TERMUX_PKG_VERSION}.tar.gz

termux_step_post_make_install () {
	# Symlink sh -> dash
	rm -f $TERMUX_PREFIX/bin/sh $TERMUX_PREFIX/share/man/man1/sh.1
	cd $TERMUX_PREFIX/bin
	ln -s dash sh
	cd $TERMUX_PREFIX/share/man/man1
	ln -s dash.1 sh.1
}
