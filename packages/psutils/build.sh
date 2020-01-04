TERMUX_PKG_HOMEPAGE=https://github.com/rrthomas/psutils
TERMUX_PKG_DESCRIPTION="A set of postscript utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.90
TERMUX_PKG_SRCURL=https://github.com/rrthomas/psutils/releases/download/v$TERMUX_PKG_VERSION/psutils-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6685035adacc7c5dbbae8ca95abce03e4535164fd5e661d5393e00a7b8cc1fad
TERMUX_PKG_DEPENDS="ghostscript, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_massage() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)

	# Make sure that perl can find PSUtils module.
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/${perl_version}"
	mv -f "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/perl/PSUtils.pm \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/${perl_version}"/
	rm -rf "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/perl
}
