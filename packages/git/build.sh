TERMUX_PKG_HOMEPAGE=https://git-scm.com/
TERMUX_PKG_DESCRIPTION="Distributed version control system designed to handle everything from small to very large projects with speed and efficiency"
# less is required as a pager for git log, and the busybox less does not handle used escape sequences.
TERMUX_PKG_DEPENDS="libcurl, less, openssl"
TERMUX_PKG_VERSION=2.14.1
TERMUX_PKG_SHA256=6f724c6d0e9e13114ab35db6f67e1b2c1934b641e89366e6a0e37618231f2cc6
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
TERMUX_PKG_EXTRA_MAKE_ARGS="NO_NSEC=1 NO_GETTEXT=1 NO_EXPAT=1 NO_INSTALL_HARDLINKS=1 PERL_PATH=$TERMUX_PREFIX/bin/perl"
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

termux_step_pre_configure () {
	# Setup perl so that the build process can execute it:
	rm -f $TERMUX_PREFIX/bin/perl
	ln -s `which perl` $TERMUX_PREFIX/bin/perl

	# Force fresh perl files (otherwise files from earlier builds
	# remains without bumped modification times, so are not picked
	# up by the package):
	rm -Rf $TERMUX_PREFIX/share/git-perl

	# Fixes build if utfcpp is installed:
	CPPFLAGS="-I$TERMUX_PKG_SRCDIR $CPPFLAGS"
}

termux_step_post_make_install () {
	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make -j $TERMUX_MAKE_PROCESSES man
	make install-man

	# Build contrib projects
	make -C $TERMUX_PKG_SRCDIR/contrib/diff-highlight ${TERMUX_PKG_EXTRA_MAKE_ARGS}
	make -C $TERMUX_PKG_SRCDIR/contrib/emacs ${TERMUX_PKG_EXTRA_MAKE_ARGS}
	make -C $TERMUX_PKG_SRCDIR/contrib/subtree ${TERMUX_PKG_EXTRA_MAKE_ARGS}

	termux_setup_golang
	make -C $TERMUX_PKG_SRCDIR/contrib/persistent-https

	# Install contrib projects
	make -C $TERMUX_PKG_SRCDIR/contrib/subtree ${TERMUX_PKG_EXTRA_MAKE_ARGS} install install-doc
	make -C $TERMUX_PKG_SRCDIR/contrib/emacs ${TERMUX_PKG_EXTRA_MAKE_ARGS} install

	mv $TERMUX_PKG_SRCDIR/contrib/persistent-https/git-remote-persistent-http* $TERMUX_PREFIX/bin

	find $TERMUX_PKG_SRCDIR/contrib/ -name '.gitignore' -delete
	cp -r $TERMUX_PKG_SRCDIR/contrib $TERMUX_PREFIX/share/git-core/

	mkdir -p $TERMUX_PREFIX/etc/bash_completion.d/
	ln -s -f $TERMUX_PREFIX/share/git-core/contrib/completion/git-completion.bash \
	   $TERMUX_PREFIX/etc/bash_completion.d/git-completion.bash

	# Remove the build machine perl setup in termux_step_pre_configure to avoid it being packaged:
	rm $TERMUX_PREFIX/bin/perl

	# Remove clutter:
	rm -Rf $TERMUX_PREFIX/lib/*-linux*/perl

	# Remove duplicated binaries in bin/ with symlink to the one in libexec/git-core:
	(cd $TERMUX_PREFIX/bin; ln -s -f ../libexec/git-core/git git)
	(cd $TERMUX_PREFIX/bin; ln -s -f ../libexec/git-core/git-upload-pack git-upload-pack)
}

termux_step_post_massage () {
	if [ ! -f libexec/git-core/git-remote-https ]; then
		termux_error_exit "Git built without https support"
	fi
}
