TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=asciinema-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make () {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_TMPDIR
	cd $GOPATH
	mkdir -p src/github.com/asciinema/asciinema/
	cp -Rf $TERMUX_PKG_SRCDIR/* src/github.com/asciinema/asciinema/
}

termux_step_make_install () {
	cd $GOPATH/src/github.com/asciinema/asciinema
	PREFIX=$TERMUX_PREFIX make build
	PREFIX=$TERMUX_PREFIX make install

	cp $TERMUX_PKG_SRCDIR/man/asciinema.1 $TERMUX_PREFIX/share/man/man1/
}
