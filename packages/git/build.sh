TERMUX_PKG_HOMEPAGE=http://git-scm.com/
TERMUX_PKG_DESCRIPTION="Distributed version control system designed to handle everything from small to very large projects with speed and efficiency"
# less is required as a pager for git log, and the busybox less does not handle used escape sequences.
TERMUX_PKG_DEPENDS="libcurl, less"
TERMUX_PKG_VERSION=2.8.1
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${TERMUX_PKG_VERSION}.tar.xz
## This requires a working $TERMUX_PREFIX/bin/sh on the host building:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-tcltk --with-curl --with-shell=$TERMUX_PREFIX/bin/sh ac_cv_header_libintl_h=no ac_cv_fread_reads_directories=yes ac_cv_snprintf_returns_bogus=yes"
# expat is only used by git-http-push for remote lock management over DAV, so disable:
# NO_INSTALL_HARDLINKS to use symlinks instead of hardlinks (which does not work on Android M):
TERMUX_PKG_EXTRA_MAKE_ARGS="NO_NSEC=1 NO_GETTEXT=1 NO_EXPAT=1 NO_INSTALL_HARDLINKS=1 PERL_PATH=$TERMUX_PREFIX/bin/perl"
TERMUX_PKG_BUILD_IN_SRC="yes"

# Things to remove to save space:
#  bin/git-cvsserver - server emulating CVS
#  bin/git-shell - restricted login shell for Git-only SSH access
TERMUX_PKG_RM_AFTER_INSTALL="bin/git-cvsserver bin/git-shell Library"

termux_step_pre_configure () {
	# Setup perl so that the build process can execute it:
	rm -f $TERMUX_PREFIX/bin/perl
	ln -s `which perl` $TERMUX_PREFIX/bin/perl

	# Force fresh perl files (otherwise files from earlier builds
	# remains without bumped modification times, so are not picked
	# up by the package):
	rm -Rf $TERMUX_PREFIX/share/git-perl
}

termux_step_post_make_install () {
	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make install-man

	mkdir -p $TERMUX_PREFIX/etc/bash_completion.d/
	cp $TERMUX_PKG_SRCDIR/contrib/completion/git-completion.bash \
	   $TERMUX_PREFIX/etc/bash_completion.d/

	# Remove the build machine perl setup in termux_step_pre_configure to avoid it being packaged:
	rm $TERMUX_PREFIX/bin/perl

	# Remove clutter:
	rm -Rf $TERMUX_PREFIX/lib/*-linux*/perl
}

termux_step_post_massage () {
	if [ ! -f libexec/git-core/git-remote-https ]; then
		echo "ERROR: Built without https support"
		exit 1
	fi
}
