TERMUX_PKG_HOMEPAGE=https://git-scm.com/
TERMUX_PKG_DESCRIPTION="Fast, scalable, distributed revision control system"
TERMUX_PKG_LICENSE="GPL-2.0"
# less is required as a pager for git log, and the busybox less does not handle used escape sequences.
TERMUX_PKG_DEPENDS="libcurl, libiconv, less, openssl, pcre2, zlib"
TERMUX_PKG_VERSION=2.21.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=8ccb1ce743ee991d91697e163c47c11be4bf81efbdd9fb0b4a7ad77cc0020d28
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${TERMUX_PKG_VERSION}.tar.xz
## This requires a working $TERMUX_PREFIX/bin/sh on the host building:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_fread_reads_directories=yes
ac_cv_header_libintl_h=no
ac_cv_snprintf_returns_bogus=no
--with-curl
--without-tcltk
--with-shell=$TERMUX_PREFIX/bin/sh
"
# expat is only used by git-http-push for remote lock management over DAV, so disable:
# NO_INSTALL_HARDLINKS to use symlinks instead of hardlinks (which does not work on Android M):
TERMUX_PKG_EXTRA_MAKE_ARGS="
NO_NSEC=1
NO_GETTEXT=1
NO_EXPAT=1
NO_INSTALL_HARDLINKS=1
PERL_PATH=$TERMUX_PREFIX/bin/perl
USE_LIBPCRE2=1
"
TERMUX_PKG_BUILD_IN_SRC="yes"

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
	# Setup perl so that the build process can execute it:
	rm -f $TERMUX_PREFIX/bin/perl
	ln -s $(which perl) $TERMUX_PREFIX/bin/perl

	# Force fresh perl files (otherwise files from earlier builds
	# remains without bumped modification times, so are not picked
	# up by the package):
	rm -Rf $TERMUX_PREFIX/share/git-perl

	# Fixes build if utfcpp is installed:
	CPPFLAGS="-I$TERMUX_PKG_SRCDIR $CPPFLAGS"
}

termux_step_post_make_install() {
	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make -j $TERMUX_MAKE_PROCESSES install-man

	mkdir -p $TERMUX_PREFIX/etc/bash_completion.d/
	cp $TERMUX_PKG_SRCDIR/contrib/completion/git-completion.bash \
	   $TERMUX_PKG_SRCDIR/contrib/completion/git-prompt.sh \
	   $TERMUX_PREFIX/etc/bash_completion.d/

	# Remove the build machine perl setup in termux_step_pre_configure to avoid it being packaged:
	rm $TERMUX_PREFIX/bin/perl

	# Remove clutter:
	rm -Rf $TERMUX_PREFIX/lib/*-linux*/perl

	# Remove duplicated binaries in bin/ with symlink to the one in libexec/git-core:
	(cd $TERMUX_PREFIX/bin; ln -s -f ../libexec/git-core/git git)
	(cd $TERMUX_PREFIX/bin; ln -s -f ../libexec/git-core/git-upload-pack git-upload-pack)
}

termux_step_post_massage() {
	if [ ! -f libexec/git-core/git-remote-https ]; then
		termux_error_exit "Git built without https support"
	fi
}
