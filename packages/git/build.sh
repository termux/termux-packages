TERMUX_PKG_HOMEPAGE=https://git-scm.com/
TERMUX_PKG_DESCRIPTION="Fast, scalable, distributed revision control system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.55.0"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/pub/software/scm/git/git-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=457fdb04dc8728e007d4688695e6912e6f680727920f2a40bf11eacc17505357
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, libexpat, libiconv, less, openssl, pcre2, zlib"
TERMUX_PKG_RECOMMENDS="openssh"
TERMUX_PKG_SUGGESTS="perl"

## This requires a working $TERMUX_PREFIX/bin/sh on the host building:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_fread_reads_directories=yes
ac_cv_header_libintl_h=no
ac_cv_iconv_omits_bom=no
ac_cv_snprintf_returns_bogus=no
--with-curl
--with-expat
--with-shell=$TERMUX_PREFIX/bin/sh
--with-tcltk=$TERMUX_PREFIX/bin/wish
"
# expat is only used by git-http-push for remote lock management over DAV, so disable:
# NO_INSTALL_HARDLINKS to use symlinks instead of hardlinks (which does not work on Android M):
TERMUX_PKG_EXTRA_MAKE_ARGS="
NO_NSEC=1
NO_GETTEXT=1
NO_INSTALL_HARDLINKS=1
INSTALL_SYMLINKS=1
CSPRNG_METHOD=openssl
USE_LIBPCRE2=1
DEFAULT_PAGER=pager
DEFAULT_EDITOR=editor
"
TERMUX_PKG_MAKE_INSTALL_TARGET="install install-man"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	export CARGO_BUILD_TARGET="$CARGO_TARGET_NAME"
	# Fixes build if utfcpp is installed:
	CPPFLAGS="-I$TERMUX_PKG_SRCDIR $CPPFLAGS"
}

termux_step_make_install() {
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
	make -C contrib/subtree -j "${TERMUX_PKG_MAKE_PROCESSES}" ${TERMUX_PKG_EXTRA_MAKE_ARGS} ${TERMUX_PKG_MAKE_INSTALL_TARGET}
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/bash_completion.d/"
	cp "$TERMUX_PKG_SRCDIR/contrib/completion/git-completion.bash" \
		"$TERMUX_PKG_SRCDIR/contrib/completion/git-prompt.sh" \
		"$TERMUX_PREFIX/etc/bash_completion.d/"
}

termux_step_post_massage() {
	if [[ ! -f libexec/git-core/git-remote-https ]]; then
		termux_error_exit "Git built without https support"
	fi
}
