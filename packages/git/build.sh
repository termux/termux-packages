TERMUX_PKG_HOMEPAGE=http://git-scm.com/
TERMUX_PKG_DESCRIPTION="Distributed version control system designed to handle everything from small to very large projects with speed and efficiency"
TERMUX_PKG_DEPENDS="openssl, libcurl"
TERMUX_PKG_VERSION=2.6.1
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${TERMUX_PKG_VERSION}.tar.xz
## This requires a /system/bin/sh on the host building:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-tcltk --with-curl --with-shell=/system/bin/sh ac_cv_header_libintl_h=no ac_cv_fread_reads_directories=yes ac_cv_snprintf_returns_bogus=yes"
# expat is only used by git-http-push for remote lock management over DAV, so disable:
# NO_INSTALL_HARDLINKS to use symlinks instead of hardlinks (which does not work on Android M):
TERMUX_PKG_EXTRA_MAKE_ARGS="NO_NSEC=1 NO_PERL=1 NO_GETTEXT=1 NO_EXPAT=1 NO_INSTALL_HARDLINKS=1 PERL_PATH=$TERMUX_PREFIX/bin/perl"
TERMUX_PKG_BUILD_IN_SRC="yes"

# Things to remove to save space:
#  bin/git-cvsserver - server emulating CVS
#  bin/git-shell - restricted login shell for Git-only SSH access
#  lib/perl5 - perl scripts
TERMUX_PKG_RM_AFTER_INSTALL="bin/git-cvsserver bin/git-shell lib/perl5 Library"

termux_step_post_make_install () {
	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make install-man
}
