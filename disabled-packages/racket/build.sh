TERMUX_PKG_HOMEPAGE=https://racket-lang.org
TERMUX_PKG_DESCRIPTION="Full-spectrum programming language going beyond Lisp and Scheme"
TERMUX_PKG_VERSION=6.3
TERMUX_PKG_SRCURL=https://mirror.racket-lang.org/releases/6.3/installers/racket-minimal-${TERMUX_PKG_VERSION}-src-builtpkgs.tgz
TERMUX_PKG_DEPENDS="libffi, libandroid-support"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
# TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_FOLDERNAME=racket-${TERMUX_PKG_VERSION}
TERMUX_MAKE_PROCESSES=1

termux_step_post_extract_package () {
	export TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
}
