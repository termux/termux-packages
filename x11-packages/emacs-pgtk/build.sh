TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/emacs/
TERMUX_PKG_DESCRIPTION="Extensible, customizable text editor-and more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=29.0.60
TERMUX_PKG_SRCURL=https://github.com/emacs-mirror/emacs.git
# emacs-29 as of 2022-12-12
TERMUX_PKG_GIT_BRANCH=emacs-29
# TERMUX_PKG_GIT_BRANCH=19ef86f775a39eab46231c3eb6fc702e06857a5a
# TERMUX_PKG_SHA256=75c2ea4dc648078bb88cb8b8980693d1c5a2d6cd077393dcab12b198c5b57e67
TERMUX_PKG_DEPENDS="fontconfig, freetype, gdk-pixbuf, giflib, glib, gtk3, harfbuzz, libgmp, libgnutls, libice, libjansson, libjpeg-turbo, libpng, librsvg, libsm, libtiff, libx11, libxaw, libxcb, libxext, libxfixes, libxft, libxinerama, libxml2, libxmu, libxpm, libxrandr, libxrender, libxt, littlecms, ncurses, zlib"
TERMUX_PKG_CONFLICTS="emacs, emacs-x"
TERMUX_PKG_REPLACES="emacs, emacs-x"
TERMUX_PKG_PROVIDES="emacs, emacs-x"
TERMUX_PKG_SERVICE_SCRIPT=("emacsd" 'exec emacs --fg-daemon 2>&1')
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-autodepend
--without-cairo
--without-imagemagick
--without-libotf
--without-xaw3d
--without-gpm
--without-dbus
--without-gconf
--without-gsettings
--with-pgtk
--without-selinux
--with-modules
--with-pdumper=yes
--with-dumping=none
--with-json
"

if $TERMUX_DEBUG_BUILD; then
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	--enable-checking=yes,glyphs
	--enable-check-lisp-object-type
	"
	CFLAGS+=" -gdwarf-4"
fi

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
TERMUX_PKG_HOSTBUILD=true

# Remove some irrelevant files:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/grep-changelog
share/applications/emacs.desktop
share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.desktop
share/emacs/${TERMUX_PKG_VERSION}/etc/emacs.icon
share/emacs/${TERMUX_PKG_VERSION}/etc/images
share/emacs/${TERMUX_PKG_VERSION}/etc/refcards
share/emacs/${TERMUX_PKG_VERSION}/etc/tutorials/TUTORIAL.*
share/icons
share/man/man1/grep-changelog.1.gz
"

# Remove ctags from the emacs package to prevent conflicting with
# the Universal Ctags from the 'ctags' package (the bin/etags
# program still remain in the emacs package):
TERMUX_PKG_RM_AFTER_INSTALL+=" bin/ctags share/man/man1/ctags.1 share/man/man1/ctags.1.gz"

termux_step_post_get_source() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# XXX: We have to start with new host build each time
	#      to avoid build error when cross compiling.
	rm -Rf $TERMUX_PKG_HOSTBUILD_DIR

	# Termux only use info pages for emacs. Remove the info directory
	# to get a clean Info directory file dir.
	rm -Rf $TERMUX_PREFIX/share/info
}

termux_step_host_build() {
	# Build a bootstrap-emacs binary to be used in termux_step_post_configure.
	# Needed to compile a host arch compatible executable for el files
	local NATIVE_PREFIX=$TERMUX_PKG_TMPDIR/emacs-native
	mkdir -p $NATIVE_PREFIX/share/emacs/$TERMUX_PKG_VERSION
	ln -s $TERMUX_PKG_SRCDIR/lisp $NATIVE_PREFIX/share/emacs/$TERMUX_PKG_VERSION/lisp
	( cd $TERMUX_PKG_SRCDIR; ./autogen.sh )
	$TERMUX_PKG_SRCDIR/configure --prefix=$NATIVE_PREFIX --without-all --without-x
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_post_configure() {
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs
	cp $TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-docfile $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
	cp $TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-fingerprint $TERMUX_PKG_BUILDDIR/lib-src/make-fingerprint
	cp -r $TERMUX_PKG_SRCDIR/lisp/* $TERMUX_PKG_BUILDDIR/lisp
	cp -r $TERMUX_PKG_SRCDIR/etc $TERMUX_PKG_BUILDDIR
	# Update timestamps so that the binaries does not get rebuilt:
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs \
		$TERMUX_PKG_BUILDDIR/lib-src/make-docfile \
		$TERMUX_PKG_BUILDDIR/lib-src/make-fingerprint
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES
	mkdir -p $TERMUX_PREFIX/share/emacs/master/lisp/emacs-lisp/
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/site-init.el $TERMUX_PREFIX/share/emacs/${TERMUX_PKG_VERSION}/lisp/emacs-lisp/
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/emacs 40
		fi
	fi

	cd $TERMUX_PREFIX/share/emacs/$TERMUX_PKG_VERSION/lisp
	LC_ALL=C $TERMUX_PREFIX/bin/emacs -batch -l loadup --temacs=pdump
	mv $TERMUX_PREFIX/bin/emacs*.pdmp $TERMUX_PREFIX/libexec/emacs/$TERMUX_PKG_VERSION/${TERMUX_ARCH}-linux-android*/
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/emacs
		fi
	fi
	EOF
}
