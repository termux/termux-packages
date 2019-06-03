TERMUX_PKG_HOMEPAGE=http://www.kfish.org/software/xsel/
TERMUX_PKG_DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Doron Behar <me@doronbehar.com>"
TERMUX_PKG_VERSION=1.2.0.20190505
_commit=24bee9c7f4dc887eabb2783f21cbf9734d723d72
TERMUX_PKG_REVISION=1
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="libxt"

termux_step_extract_package() {
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	git clone https://github.com/kfish/xsel
	cd xsel
	git checkout $_commit
	./autogen.sh --prefix=$TERMUX_PREFIX
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR/xsel
	make
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR/xsel
	make install
	install -D -m0644 COPYING $TERMUX_PREFIX/share/LICENSES/xsel.txt
}
