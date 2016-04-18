TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/emacs/
TERMUX_PKG_DESCRIPTION="Extensible, customizable text editor-and more"
TERMUX_PKG_VERSION=25.0.92
TERMUX_PKG_BUILD_REVISION=7
TERMUX_PKG_SRCURL=ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="ncurses, gnutls, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --with-xpm=no --with-jpeg=no --with-png=no --with-gif=no --with-tiff=no --without-gconf --without-gsettings --with-gnutls --with-xml2"
# Ensure use of system malloc:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_sanitize_address=yes"
# Prevent configure from adding -nopie:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_prog_cc_nopie=no"
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_KEEP_INFOPAGES=yes

# Remove some irrelevant files:
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/emacs/${TERMUX_PKG_VERSION}/etc/images share/applications/emacs.desktop share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.desktop share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.icon bin/grep-changelog share/man/man1/grep-changelog.1.gz share/emacs/${TERMUX_PKG_VERSION}/etc/refcards share/emacs/${TERMUX_PKG_VERSION}/etc/tutorials/TUTORIAL.*"

# Remove ctags from the emacs package to prevent conflicting with
# the Universal Ctags from the 'ctags' package (the bin/etags
# program still remain in the emacs package):
TERMUX_PKG_RM_AFTER_INSTALL+=" bin/ctags share/man/man1/ctags.1"

termux_step_post_extract_package () {
	# XXX: We have to start with new host build each time
	#      to avoid build error when cross compiling.
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_host_build () {
	# Build a bootstrap-emacs binary to be used in termux_step_post_configure.
	$TERMUX_PKG_SRCDIR/configure --prefix=$TERMUX_PREFIX --without-x --with-xpm=no --with-jpeg=no \
	                             --with-png=no --with-tiff=no --without-gconf --without-gsettings --without-all
	make
	export CANNOT_DUMP=yes
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs
	cp $TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-docfile $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
	# Update timestamps so that the binaries does not get rebuilt:
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/site-init.el $TERMUX_PREFIX/share/emacs/${TERMUX_PKG_VERSION}/lisp/emacs-lisp/
}
