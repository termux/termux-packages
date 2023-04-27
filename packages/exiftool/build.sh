TERMUX_PKG_HOMEPAGE=https://exiftool.org/
TERMUX_PKG_DESCRIPTION="Utility for reading, writing and editing meta information in a wide variety of files."
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=12.61
TERMUX_PKG_SRCURL="https://exiftool.org/Image-ExifTool-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=a7871cd083b84a53d81d29e86cb70c22a79084e11062539ebbe327f1fa67ec30
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	local current_perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)

	install -Dm700 "$TERMUX_PKG_SRCDIR"/exiftool "$TERMUX_PREFIX"/bin/exiftool
	find "$TERMUX_PKG_SRCDIR"/lib -name "*.pod" -delete
	mkdir -p "$TERMUX_PREFIX/lib/perl5/site_perl/$current_perl_version"
	rm -rf "$TERMUX_PREFIX/lib/perl5/site_perl/${current_perl_version}"/{Image,File}
	cp -a "$TERMUX_PKG_SRCDIR"/lib/{Image,File} "$TERMUX_PREFIX/lib/perl5/site_perl/${current_perl_version}/"
}
