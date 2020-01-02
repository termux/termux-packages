TERMUX_PKG_HOMEPAGE=https://www.sno.phy.queensu.ca/~phil/exiftool/index.html
TERMUX_PKG_DESCRIPTION="Utility for reading, writing and editing meta information in a wide variety of files."
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=11.81
TERMUX_PKG_SRCURL="https://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=6784b85230b430ef357f80f729db858f9edd7664253210944d426b84515e03c0
TERMUX_PKG_DEPENDS="perl"

termux_step_make_install() {
	# Change this after package 'perl' was upgraded.
	local current_perl_version=5.30.1

	install -Dm700 "$TERMUX_PKG_SRCDIR"/exiftool "$TERMUX_PREFIX"/bin/exiftool
	find "$TERMUX_PKG_SRCDIR"/lib -name "*.pod" -delete
	mkdir -p "$TERMUX_PREFIX/lib/perl5/site_perl/${current_perl_version}"
	rm -rf "$TERMUX_PREFIX/lib/perl5/site_perl/${current_perl_version}"/{Image,File}
	cp -a "$TERMUX_PKG_SRCDIR"/lib/{Image,File} "$TERMUX_PREFIX/lib/perl5/site_perl/${current_perl_version}/"
}
