TERMUX_PKG_HOMEPAGE=https://packages.debian.org/unstable/source/libpaper
TERMUX_PKG_DESCRIPTION="Library for handling paper characteristics"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.28
TERMUX_PKG_SRCURL=https://deb.debian.org/debian/pool/main/libp/libpaper/libpaper_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c8bb946ec93d3c2c72bbb1d7257e90172a22a44a07a07fb6b802a5bb2c95fddc
TERMUX_PKG_DEPENDS="debianutils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
"

termux_step_post_configure() {
	# 210x297 is A4 size. Hard code as default.
	sed -i \
		-e "s|NL_PAPER_GET(_NL_PAPER_WIDTH)|210|g" \
		-e "s|NL_PAPER_GET(_NL_PAPER_HEIGHT)|297|g" \
		"${TERMUX_PKG_SRCDIR}"/lib/libpaper.c.in
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		mkdir -p $TERMUX_PREFIX/etc/libpaper.d
	EOF
}
