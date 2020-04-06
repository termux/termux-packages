TERMUX_PKG_HOMEPAGE=https://www.clamav.net/
TERMUX_PKG_DESCRIPTION="Anti-virus toolkit for Unix"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.102.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.clamav.net/downloads/production/clamav-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=89fcdcc0eba329ca84d270df09d2bb89ae55f5024b0c3bddb817512fb2c907d3
TERMUX_PKG_DEPENDS="json-c, libandroid-support, libbz2, libc++, libcurl, libltdl, liblzma, libxml2, openssl, pcre2, zlib"
TERMUX_PKG_BREAKS="clamav-dev"
TERMUX_PKG_REPLACES="clamav-dev"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc/clamav
--with-libcurl=$TERMUX_PREFIX
--with-pcre=$TERMUX_PREFIX
--with-libjson=$TERMUX_PREFIX
--with-openssl=$TERMUX_PREFIX
--with-xml=$TERMUX_PREFIX
--with-zlib=$TERMUX_PREFIX
--disable-clamonacc
--disable-llvm
--disable-dns"

TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5/clamav-milter.conf.5
share/man/man8/clamav-milter.8"

TERMUX_PKG_CONFFILES="
etc/clamav/clamd.conf
etc/clamav/freshclam.conf"

termux_step_pre_configure() {
       export OBJC=$CC
}

termux_step_post_make_install() {
	for conf in clamd.conf freshclam.conf; do
		sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
			"$TERMUX_PKG_BUILDER_DIR"/$conf.in \
			> "$TERMUX_PREFIX"/etc/clamav/$conf
	done
	unset conf
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/clamav
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/clamav
}
