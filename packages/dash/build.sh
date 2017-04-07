TERMUX_PKG_HOMEPAGE=http://gondor.apana.org.au/~herbert/dash/
TERMUX_PKG_DESCRIPTION="Small POSIX-compliant implementation of /bin/sh"
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_VERSION=0.5.9.1
TERMUX_PKG_SHA256=5ecd5bea72a93ed10eb15a1be9951dd51b52e5da1d4a7ae020efd9826b49e659
# Use a mirror as upstream has issues:
# TERMUX_PKG_SRCURL=http://gondor.apana.org.au/~herbert/dash/files/dash-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://dl.bintray.com/termux/upstream/dash-${TERMUX_PKG_VERSION}.tar.gz

termux_step_post_make_install () {
	# Symlink sh -> dash
	rm -f $TERMUX_PREFIX/bin/sh $TERMUX_PREFIX/share/man/man1/sh.1
	cd $TERMUX_PREFIX/bin
	ln -s dash sh
	cd $TERMUX_PREFIX/share/man/man1
	ln -s dash.1 sh.1
}
