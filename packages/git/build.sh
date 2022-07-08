TERMUX_PKG_HOMEPAGE=https://git-scm.com/
TERMUX_PKG_DESCRIPTION="Fast, scalable, distributed revision control system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.41.0
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/pub/software/scm/git/git-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e748bafd424cfe80b212cbc6f1bbccc3a47d4862fb1eb7988877750478568040
TERMUX_PKG_DEPENDS="libcurl, libiconv, less, openssl, pcre2, zlib"
TERMUX_PKG_SUGGESTS="perl"

## This requires a working $TERMUX_PREFIX/bin/sh on the host building:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_fread_reads_directories=yes
ac_cv_header_libintl_h=no
ac_cv_iconv_omits_bom=no
ac_cv_snprintf_returns_bogus=no
--with-curl
--with-shell=$TERMUX_PREFIX/bin/sh
--with-tcltk=$TERMUX_PREFIX/bin/wish
"
# expat is only used by git-http-push for remote lock management over DAV, so disable:
# NO_INSTALL_HARDLINKS to use symlinks instead of hardlinks (which does not work on Android M):
TERMUX_PKG_EXTRA_MAKE_ARGS="
NO_NSEC=1
NO_GETTEXT=1
NO_EXPAT=1
INSTALL_SYMLINKS=1
PERL_PATH=$TERMUX_PREFIX/bin/perl
USE_LIBPCRE2=1
"

TERMUX_PKG_BUILD_IN_SRC=true

# Things to remove to save space:
#  bin/git-cvsserver - server emulating CVS
#  bin/git-shell - restricted login shell for Git-only SSH access
TERMUX_PKG_RM_AFTER_INSTALL="
bin/git-cvsserver
bin/git-shell
libexec/git-core/git-shell
libexec/git-core/git-cvsserver
share/man/man1/git-cvsserver.1
share/man/man1/git-shell.1
"

termux_step_pre_configure() {
	# Fixes build if utfcpp is installed:
	CPPFLAGS="-I$TERMUX_PKG_SRCDIR $CPPFLAGS"
}

termux_step_post_make_install() {
	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make -j $TERMUX_MAKE_PROCESSES $TERMUX_PKG_EXTRA_MAKE_ARGS install-man DESTDIR=$TERMUX_PKG_MASSAGEDIR

	make -j $TERMUX_MAKE_PROCESSES -C contrib/subtree $TERMUX_PKG_EXTRA_MAKE_ARGS
	make -C contrib/subtree $TERMUX_PKG_EXTRA_MAKE_ARGS ${TERMUX_PKG_MAKE_INSTALL_TARGET} DESTDIR=$TERMUX_PKG_MASSAGEDIR
	make -j $TERMUX_MAKE_PROCESSES -C contrib/subtree $TERMUX_PKG_EXTRA_MAKE_ARGS install-man DESTDIR=$TERMUX_PKG_MASSAGEDIR

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/bash_completion.d/
	cp $TERMUX_PKG_SRCDIR/contrib/completion/git-completion.bash \
	   $TERMUX_PKG_SRCDIR/contrib/completion/git-prompt.sh \
	   $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/bash_completion.d/
}

termux_step_post_massage() {
	if [ ! -f libexec/git-core/git-remote-https ]; then
		termux_error_exit "Git built without https support"
	fi
}
