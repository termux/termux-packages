TERMUX_PKG_HOMEPAGE=https://git-scm.com/
TERMUX_PKG_DESCRIPTION="Fast, scalable, distributed revision control system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.34.1
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3a0755dd1cfab71a24dd96df3498c29cd0acd13b04f3d08bf933e81286db802c
TERMUX_PKG_DEPENDS="libcurl, libiconv, less, openssl, pcre2, zlib"

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
NO_INSTALL_HARDLINKS=1
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
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

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

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES $TERMUX_PKG_EXTRA_MAKE_ARGS
	make -j $TERMUX_MAKE_PROCESSES -C contrib/subtree $TERMUX_PKG_EXTRA_MAKE_ARGS
}

termux_step_make_install() {
	make $TERMUX_PKG_EXTRA_MAKE_ARGS install
	make -C contrib/subtree $TERMUX_PKG_EXTRA_MAKE_ARGS install

	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make -j $TERMUX_MAKE_PROCESSES install-man
	make -j $TERMUX_MAKE_PROCESSES -C contrib/subtree install-man
}

termux_step_post_make_install() {
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
