TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/iso-codes-team/iso-codes
TERMUX_PKG_DESCRIPTION="Lists of the country, language, and currency names"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.5.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/iso-codes-$TERMUX_PKG_VERSION/iso-codes-iso-codes-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=94b53580571a9ea47ea00fa476614f506083517195be1ba26faadb4813855b95
TERMUX_PKG_PLATFORM_INDEPENDENT=true

#If you install ISO codes over a previous installed version, the install step will fail when creating some symlinks

termux_step_post_configure() {
	sed -i '/^LN_S/s/s/sfvn/' */Makefile
}

termux_step_make_install() {
	make pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig install
}
