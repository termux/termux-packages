TERMUX_PKG_HOMEPAGE=https://www.djcbsoftware.nl/code/mu/
TERMUX_PKG_DESCRIPTION="Maildir indexer/searcher and Emacs client (mu4e)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.9
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/djcb/mu/releases/download/$TERMUX_PKG_VERSION-signed/mu-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=8d99430a4f6942eb3122008bb897c4480cda64b30ff4575c32ded86d7edbaf58
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="emacs, glib, libc++, libxapian, libgmime"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --disable-webkit"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "(setq byte-compile-warnings nil)" > $TERMUX_PREFIX/share/emacs/site-lisp/mu4e/nowarnings.el
	LC_ALL=C $TERMUX_PREFIX/bin/emacs -no-site-file -q -batch -l $TERMUX_PREFIX/share/emacs/site-lisp/mu4e/nowarnings.el -f batch-byte-compile $TERMUX_PREFIX/share/emacs/site-lisp/mu4e/*.el
	rm -f $TERMUX_PREFIX/share/emacs/site-lisp/mu4e/nowarnings.elc
	chmod 644 $TERMUX_PREFIX/share/emacs/site-lisp/mu4e/*.elc
	EOF

	cat <<- EOF > ./prerm
	rm -f $TERMUX_PREFIX/share/emacs/site-lisp/mu4e/*.elc
	EOF
}
