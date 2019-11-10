TERMUX_PKG_HOMEPAGE=http://pybookreader.narod.ru/misc.html
TERMUX_PKG_DESCRIPTION="Console FictionBook reader"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.2.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://deb.debian.org/debian/pool/main/f/fbless/fbless_${TERMUX_PKG_VERSION}.orig.tar.gz
TERMUX_PKG_SHA256=68ae914d141da913ed6ff1805a1739346c33756b64a9407c14e95e278452c362
TERMUX_PKG_DEPENDS="ncurses, python2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	export PYTHONPATH="$TERMUX_PREFIX/lib/python2.7/site-packages/"
	python2.7 setup.py install --prefix="$TERMUX_PREFIX" --force
}
