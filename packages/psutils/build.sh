TERMUX_PKG_HOMEPAGE=https://github.com/rrthomas/psutils
TERMUX_PKG_DESCRIPTION="A set of postscript utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.08
TERMUX_PKG_SRCURL=https://github.com/rrthomas/psutils/releases/download/v$TERMUX_PKG_VERSION/psutils-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0c8b0168cec3c22a16d870ae345e7b9c5d2db84fa146094866c1c19a93ce8a00
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ghostscript, perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_massage() {
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)

	# Make sure that perl can find PSUtils module.
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/${perl_version}"
	mv -f "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/psutils/PSUtils.pm \
		"$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/perl5/${perl_version}"/
	rmdir "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/share/psutils
}
