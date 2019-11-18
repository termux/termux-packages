TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/emacs/
TERMUX_PKG_DESCRIPTION="Extensible, customizable text editor-and more (with X11 support)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=26.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/emacs/emacs-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4d90e6751ad8967822c6e092db07466b9d383ef1653feb2f95c93e7de66d3485
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, giflib, glib, gtk3, libandroid-shmem, libcairo, libgnutls, libice, libjpeg-turbo, libpng, librsvg, libsm, libtiff, libx11, libxcb, libxext, libxfixes, libxft, libxinerama, libxml2, libxpm, libxrandr, libxrender, littlecms, ncurses, pango, zlib"
TERMUX_PKG_CONFLICTS="emacs"
TERMUX_PKG_REPLACES="emacs"
TERMUX_PKG_PROVIDES="emacs"
TERMUX_PKG_CONFFILES="var/service/emacsd/run var/service/emacsd/log/run"
TERMUX_PKG_HOSTBUILD=true

# Remove some irrelevant files:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/ctags
bin/grep-changelog
share/emacs/${TERMUX_PKG_VERSION}/etc/images
share/emacs/${TERMUX_PKG_VERSION}/etc/refcards
share/info/dir
share/man/man1/ctags.1
share/man/man1/ctags.1.gz
share/man/man1/grep-changelog.1.gz"

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
--with-x
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

termux_step_post_extract_package() {
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

ermux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}

termux_step_post_configure() {
	cp $TERMUX_PKG_HOSTBUILD_DIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs
	cp $TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-docfile $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
	# Update timestamps so that the binaries does not get rebuilt:
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/src/bootstrap-emacs $TERMUX_PKG_BUILDDIR/lib-src/make-docfile
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/site-init.el $TERMUX_PREFIX/share/emacs/${TERMUX_PKG_VERSION}/lisp/emacs-lisp/

	# Setup emacs --daemon service script
	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	mkdir -p emacsd/log
	echo "#!$TERMUX_PREFIX/bin/sh" > emacsd/run
	echo 'exec emacs --fg-daemon 2>&1' >> emacsd/run
	chmod +x emacsd/run
	touch emacsd/down

	ln -sf $TERMUX_PREFIX/share/termux-services/svlogger emacsd/log/run
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
