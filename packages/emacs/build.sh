TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/emacs/
TERMUX_PKG_DESCRIPTION="Extensible, customizable text editor-and more"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Update both emacs and emacs-x to the same version in one PR.
TERMUX_PKG_VERSION=30.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/emacs/emacs-${TERMUX_PKG_VERSION}.tar.xz
if [[ $TERMUX_PKG_VERSION == *-rc* ]]; then
	TERMUX_PKG_SRCURL=https://alpha.gnu.org/gnu/emacs/pretest/emacs-${TERMUX_PKG_VERSION#*:}.tar.xz
fi
TERMUX_PKG_SHA256=6ccac1ae76e6af93c6de1df175e8eb406767c23da3dd2a16aa67e3124a6f138f
TERMUX_PKG_DEPENDS="libgmp, libgnutls, libsqlite, libxml2, ncurses, tree-sitter, zlib"
TERMUX_PKG_BREAKS="emacs-dev"
TERMUX_PKG_REPLACES="emacs-dev"
TERMUX_PKG_SERVICE_SCRIPT=("emacsd" 'exec emacs --fg-daemon 2>&1')
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-autodepend
--with-dumping=none
--with-gif=no
--with-gnutls
--with-jpeg=no
--with-modules
--with-pdumper=yes
--with-png=no
--with-tiff=no
--with-xml2
--with-xpm=no
--with-tree-sitter
--without-dbus
--without-gconf
--without-gsettings
--without-lcms2
--without-selinux
--without-x
"

if $TERMUX_DEBUG_BUILD; then
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
	--enable-checking=yes,glyphs
	--enable-check-lisp-object-type
	"
	CFLAGS+=" -gdwarf-4"
fi

# Avoid misdetection of sigaltstack with strict C99:
# https://github.com/termux/termux-packages/issues/15852
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_alternate_stack=yes"
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
if [ "$TERMUX_ARCH" == "arm" ] || [ "$TERMUX_ARCH" == "i686" ]; then
	# setjmp does not work properly on 32bit android:
	# https://github.com/termux/termux-packages/issues/2599
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_func__setjmp=no"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" emacs_cv_func_sigsetjmp=no"
fi
TERMUX_PKG_HOSTBUILD=true

# Remove some irrelevant files:
TERMUX_PKG_RM_AFTER_INSTALL="
bin/grep-changelog
lib/systemd
share/man/man1/grep-changelog.1.gz
"

# Remove ctags from the emacs package to prevent conflicting with
# the Universal Ctags from the 'ctags' package (the bin/etags
# program still remain in the emacs package):
TERMUX_PKG_RM_AFTER_INSTALL+=" bin/ctags share/man/man1/ctags.1 share/man/man1/ctags.1.gz"

# Get shellcheck to shut up about "$TERMUX_PKG_VERSION"
# getting reassigned in a subshell down below.
# shellcheck disable=SC2031
termux_step_post_get_source() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Version guard
	local ver_e ver_x
	ver_e="${TERMUX_PKG_VERSION#*:}"
	ver_x="$(. "$TERMUX_SCRIPTDIR/x11-packages/emacs-x/build.sh"; echo "${TERMUX_PKG_VERSION#*:}")"
	if [ "${ver_e}" != "${ver_x}" ]; then
		termux_error_exit "Version mismatch between emacs and emacs-x."
	fi

	# XXX: We have to start with new host build each time
	#      to avoid build error when cross compiling.
	rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"

	# Termux only use info pages for emacs. Remove the info directory
	# to get a clean Info directory file dir.
	rm -Rf "$TERMUX_PREFIX/share/info"
}

# shellcheck disable=SC2031
termux_step_host_build() {
	local _VERSION="${TERMUX_PKG_VERSION#*:}"
	# Build a bootstrap-emacs binary to be used in termux_step_post_configure.
	local NATIVE_PREFIX=$TERMUX_PKG_TMPDIR/emacs-native
	mkdir -p "$NATIVE_PREFIX/share/emacs/${_VERSION}"
	ln -s "$TERMUX_PKG_SRCDIR/lisp" "$NATIVE_PREFIX/share/emacs/${_VERSION}/lisp"
	( cd "$TERMUX_PKG_SRCDIR" && ./autogen.sh )
	"$TERMUX_PKG_SRCDIR/configure" --prefix="$NATIVE_PREFIX" --without-all --without-x
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_post_configure() {
	cp "$TERMUX_PKG_HOSTBUILD_DIR/src/bootstrap-emacs" "$TERMUX_PKG_BUILDDIR/src/bootstrap-emacs"
	cp "$TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-docfile" "$TERMUX_PKG_BUILDDIR/lib-src/make-docfile"
	cp "$TERMUX_PKG_HOSTBUILD_DIR/lib-src/make-fingerprint" "$TERMUX_PKG_BUILDDIR/lib-src/make-fingerprint"
	cp -r "$TERMUX_PKG_SRCDIR/lisp"/* "$TERMUX_PKG_BUILDDIR/lisp"
	cp -r "$TERMUX_PKG_SRCDIR/etc" "$TERMUX_PKG_BUILDDIR"
	# Update timestamps so that the binaries does not get rebuilt:
	touch -d "next hour" "$TERMUX_PKG_BUILDDIR/src/bootstrap-emacs" \
		"$TERMUX_PKG_BUILDDIR/lib-src/make-docfile" \
		"$TERMUX_PKG_BUILDDIR/lib-src/make-fingerprint"
}

# shellcheck disable=SC2031
termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/share/emacs/${TERMUX_PKG_VERSION}/lisp/emacs-lisp/"
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/site-start.el" \
		"$TERMUX_PREFIX/share/emacs/site-lisp/site-start.el"
}

# shellcheck disable=SC2031
termux_step_create_debscripts() {
	local _VERSION="${TERMUX_PKG_VERSION#*:}"
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	cd $TERMUX_PREFIX/share/emacs/${_VERSION}/lisp
	LC_ALL=C $TERMUX_PREFIX/bin/emacs -batch -l loadup --temacs=pdump
	mv $TERMUX_PREFIX/bin/emacs*.pdmp $TERMUX_PREFIX/libexec/emacs/${_VERSION}/${TERMUX_ARCH}-linux-android*/
	EOF
}
