TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/emacs/
TERMUX_PKG_DESCRIPTION="Extensible, customizable text editor—and more"
TERMUX_PKG_VERSION=24.5
TERMUX_PKG_SRCURL=http://ftp.gnu.org/pub/gnu/emacs/emacs-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-x --with-xpm=no --with-jpeg=no --with-png=no --with-gif=no --with-tiff=no --without-gconf --without-gsettings --without-all"
TERMUX_PKG_HOSTBUILD="yes"

# Note that we remove leim:
TERMUX_PKG_RM_AFTER_INSTALL="share/icons share/emacs/${TERMUX_PKG_VERSION}/etc/images share/applications/emacs.desktop share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.desktop share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.icon bin/grep-changelog share/man/man1/grep-changelog.1.gz share/emacs/${TERMUX_PKG_VERSION}/etc/refcards share/emacs/${TERMUX_PKG_VERSION}/etc/tutorials/TUTORIAL.* share/emacs/${TERMUX_PKG_VERSION}/leim"

# http://www.gnu.org/software/emacs/manual/html_node/elisp/Building-Emacs.html#Building-Emacs
# "Compilation of the C source files in the src directory produces an executable file called temacs, also called a
# bare impure Emacs. It contains the Emacs Lisp interpreter and I/O routines, but not the editing commands.
# The command temacs -l loadup would run temacs and direct it to load loadup.el. The loadup library loads additional Lisp libraries,
# which set up the normal Emacs editing environment. After this step, the Emacs executable is no longer bare.
# Because it takes some time to load the standard Lisp files, the temacs executable usually isn't run directly by users. Instead, as
# one of the last steps of building Emacs, the command ‘temacs -batch -l loadup dump’ is run. The special ‘dump’ argument causes temacs
# to dump out an executable program, called emacs, which has all the standard Lisp files preloaded. (The ‘-batch’ argument prevents
# temacs from trying to initialize any of its data on the terminal, so that the tables of terminal information are empty in the dumped Emacs.)"

########## FROM src/Makefile:
## The dumped Emacs is as functional and more efficient than
## bootstrap-emacs, so we replace the latter with the former.
## Strictly speaking, emacs does not depend directly on all of $lisp,
## since not all pieces are used on all platforms.  But DOC depends
## on all of $lisp, and emacs depends on DOC, so it is ok to use $lisp here.
# emacs$(EXEEXT): temacs$(EXEEXT) $(etc)/DOC $(lisp) $(leimdir)/leim-list.el
# if test "$(CANNOT_DUMP)" = "yes"; then \
# 	rm -f emacs$(EXEEXT); \
# 	ln temacs$(EXEEXT) emacs$(EXEEXT); \
# else \
#	LC_ALL=C $(RUN_TEMACS) -batch -l loadup dump || exit 1; \
# 	test "X$(PAXCTL)" = X || $(PAXCTL) -zex emacs$(EXEEXT); \
#	rm -f bootstrap-emacs$(EXEEXT); \
# 	ln emacs$(EXEEXT) bootstrap-emacs$(EXEEXT); \
# fi
 
# so emacs => temacs, and then it tries to execute emacs, leading to error

# We can build without dump, but a bootstrap-emacs is still needed to produce bytecode-compiled (platform-independent) emacs lisp .elc files.

termux_step_host_build () {
	$TERMUX_PKG_SRCDIR/configure $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
	make
}

termux_step_pre_configure () {
	export CANNOT_DUMP=yes
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs
	cp $TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-docfile $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
	# Update timestamps so that the binaries does not get rebuilt:
	$TERMUX_TOUCH -d "next hour" $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
}

termux_step_post_make_install () {
	rm $TERMUX_PREFIX/bin/emacs $TERMUX_PREFIX/bin/emacs-$TERMUX_PKG_VERSION
	echo "#!/system/bin/sh" > $TERMUX_PREFIX/bin/emacs
	echo "exec temacs -l loadup" >> $TERMUX_PREFIX/bin/emacs
	chmod +x $TERMUX_PREFIX/bin/emacs
	cp $TERMUX_PKG_BUILDDIR/src/temacs $TERMUX_PREFIX/bin/temacs
}

