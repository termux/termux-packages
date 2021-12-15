TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=a647bfefed14d2221fa77b6edac594934dc672c4a560417b1abcbbc6b88d769f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libandroid-glob, libiconv, libotr, ncurses, openssl, perl, utf8proc"
TERMUX_PKG_BREAKS="irssi-dev"
TERMUX_PKG_REPLACES="irssi-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_perlpath=$TERMUX_PREFIX/bin/perl
--enable-true-color
--with-socks
--with-otr=static
--with-perl=static
"

termux_step_pre_configure() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)

	# Irssi has no support for cross-compiling perl module,
	# so we add it ourselves.
	sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_PERL_VERSION@|$perl_version|g" \
		-e "s|@TERMUX_PERL_TARGET@|${TERMUX_ARCH}-android|g" \
		$TERMUX_PKG_BUILDER_DIR/perl_config_support.patch.txt | \
		patch -p1
	autoconf
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-perl-lib=$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android"

	LDFLAGS+=" -landroid-glob"

	# Make build log less noisy.
	CFLAGS+=" -Wno-deprecated-declarations"

	# Make sure that perl stuff is reinstalled.
	rm -rf $TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/x86_64-linux-gnu-thread-multi
}

termux_step_post_massage() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	mv $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/x86_64-linux-gnu-thread-multi/* \
		$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/
	rm -rf $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android/x86_64-linux-gnu-thread-multi
}
