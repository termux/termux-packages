TERMUX_PKG_HOMEPAGE=https://irssi.org/
TERMUX_PKG_DESCRIPTION="Terminal based IRC client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/irssi/irssi/releases/download/$TERMUX_PKG_VERSION/irssi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=79a4765d2dfe153c440a1775b074d5d0682b96814c7cf92325b5e15ce50e26a8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libandroid-glob, libiconv, libotr, ncurses, openssl, perl, utf8proc"
TERMUX_PKG_BREAKS="irssi-dev"
TERMUX_PKG_REPLACES="irssi-dev"
TERMUX_MESON_PERL_CROSS_FILE=$TERMUX_PKG_TMPDIR/meson-perl-cross-$TERMUX_ARCH.txt
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dfhs-prefix=$TERMUX_PREFIX
--cross-file $TERMUX_MESON_PERL_CROSS_FILE
"

termux_step_configure() {
	termux_step_configure_meson
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"

	# Make build log less noisy.
	CFLAGS+=" -Wno-compound-token-split-by-macro"

	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)

	cat <<- MESON_PERL_CROSS >$TERMUX_MESON_PERL_CROSS_FILE
	[properties]
	perl_version = '$perl_version'
	perl_ccopts = ['-I$TERMUX_PREFIX/include', '-D_LARGEFILE_SOURCE', '-D_FILE_OFFSET_BITS=64', '-I$TERMUX_PREFIX/lib/perl5/$perl_version/${TERMUX_ARCH}-android/CORE']
	perl_ldopts = ['-Wl,-E', '-I$TERMUX_PREFIX/include', '-L$TERMUX_PREFIX/lib/perl5/$perl_version/${TERMUX_ARCH}-android/CORE', '-lperl', '-lm', '-ldl']
	perl_archname = '${TERMUX_ARCH}-android'
	perl_installsitearch = '$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android'
	perl_installvendorarch = ''
	perl_inc = ['$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version/${TERMUX_ARCH}-android', '$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version', '$TERMUX_PREFIX/lib/perl5/$perl_version/${TERMUX_ARCH}-android', '$TERMUX_PREFIX/lib/perl5/$perl_version']
	MESON_PERL_CROSS
}
