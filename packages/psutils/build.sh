TERMUX_PKG_HOMEPAGE=https://github.com/rrthomas/psutils
TERMUX_PKG_DESCRIPTION="A set of postscript utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.06
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/rrthomas/psutils/releases/download/v$TERMUX_PKG_VERSION/psutils-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b61de4bf7d4ac8b63a06ed1b9cf9587418707e856258b9bf616f7dc91bc3cce9
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
