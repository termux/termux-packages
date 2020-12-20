TERMUX_PKG_HOMEPAGE=https://github.com/rrthomas/psutils
TERMUX_PKG_DESCRIPTION="A set of postscript utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.04
TERMUX_PKG_SRCURL=https://github.com/rrthomas/psutils/releases/download/v$TERMUX_PKG_VERSION/psutils-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6e25e3a04d769cf591f8f3b346626f6a7d0fdf9c4ae2ac9bedd5df8eef8210ad
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
