TERMUX_PKG_HOMEPAGE=https://en.wikipedia.org/wiki/Cowsay
TERMUX_PKG_DESCRIPTION="Program which generates ASCII pictures of a cow with a message"
TERMUX_PKG_VERSION=3.03
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/c/cowsay/cowsay_3.03+dfsg1.orig.tar.gz
TERMUX_PKG_FOLDERNAME=cowsay-3.03+dfsg1
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR
	sh install.sh
}
