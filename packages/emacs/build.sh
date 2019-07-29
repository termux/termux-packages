TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/emacs/
TERMUX_PKG_DESCRIPTION="Extensible, customizable text editor-and more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=26.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=151ce69dbe5b809d4492ffae4a4b153b2778459de6deb26f35691e1281a9c58e
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/emacs/emacs-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="ncurses, gnutls, libxml2"
TERMUX_PKG_BREAKS="emacs-dev"
TERMUX_PKG_REPLACES="emacs-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-autodepend
--with-gif=no
--with-gnutls
--with-jpeg=no
--without-gconf
--without-gsettings
--without-lcms2
--without-x
--with-png=no
--with-tiff=no
--with-xml2
--with-xpm=no
--without-dbus
"
# Ensure use of system malloc:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_sanitize_address=yes"
# Prevent configure from adding -nopie:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_prog_cc_no_pie=no"
# Prevent linking against libelf:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_elf_elf_begin=no"
# implemented using dup3(), which fails if oldfd == newfd
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" gl_cv_func_dup2_works=no"
# disable setrlimit function to make termux-am work from within emacs
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_setrlimit=no"
TERMUX_PKG_HOSTBUILD=yes

# Remove some irrelevant files:
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/emacs/${TERMUX_PKG_VERSION}/etc/images share/applications/emacs.desktop share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.desktop share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.icon bin/grep-changelog share/man/man1/grep-changelog.1.gz share/emacs/${TERMUX_PKG_VERSION}/etc/refcards share/emacs/${TERMUX_PKG_VERSION}/etc/tutorials/TUTORIAL.*"

# Remove ctags from the emacs package to prevent conflicting with
# the Universal Ctags from the 'ctags' package (the bin/etags
# program still remain in the emacs package):
TERMUX_PKG_RM_AFTER_INSTALL+=" bin/ctags share/man/man1/ctags.1 share/man/man1/ctags.1.gz"

termux_step_post_extract_package() {
	# XXX: We have to start with new host build each time
	#      to avoid build error when cross compiling.
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR

	# Termux only use info pages for emacs. Remove the info directory
	# to get a clean Info directory file dir.
	rm -Rf $TERMUX_PREFIX/share/info

	# We cannot run a dumped emacs on Android 5.0+ due to the pie requirement.
	# Also, the native emacs we build (bootstrap-emacs) cannot used dumps when
	# building inside docker: https://github.com/docker/docker/issues/22801
	export CANNOT_DUMP=yes
}

termux_step_host_build() {
	# Build a bootstrap-emacs binary to be used in termux_step_post_configure.
	local NATIVE_PREFIX=$TERMUX_PKG_TMPDIR/emacs-native
	mkdir -p $NATIVE_PREFIX/share/emacs/$TERMUX_PKG_VERSION
	ln -s $TERMUX_PKG_SRCDIR/lisp $NATIVE_PREFIX/share/emacs/$TERMUX_PKG_VERSION/lisp

	$TERMUX_PKG_SRCDIR/configure --prefix=$NATIVE_PREFIX --without-all --with-x-toolkit=no
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_post_configure() {
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs
	cp $TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-docfile $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
	# Update timestamps so that the binaries does not get rebuilt:
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/site-init.el $TERMUX_PREFIX/share/emacs/${TERMUX_PKG_VERSION}/lisp/emacs-lisp/
}
