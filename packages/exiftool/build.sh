TERMUX_PKG_HOMEPAGE=https://exiftool.org/
TERMUX_PKG_DESCRIPTION="Utility for reading, writing and editing meta information in a wide variety of files."
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="13.64"
TERMUX_PKG_SRCURL="https://github.com/exiftool/exiftool/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6ed24bfbe1ce38d0e7800f8e4132f9bfce2a29f4256d924d0458f59fd64b513a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
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
