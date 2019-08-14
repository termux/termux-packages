TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/iso-codes-team/iso-codes
TERMUX_PKG_DESCRIPTION="Lists of the country, language, and currency names"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://salsa.debian.org/iso-codes-team/iso-codes/uploads/049ce6aac94d842be809f4063950646c/iso-codes-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=67117fb76f32c8fb5e37d2d60bce238f1f8e865cc7b569a57cbc3017ca15488a
TERMUX_PKG_PLATFORM_INDEPENDENT=true

#If you install ISO codes over a previous installed version, the install step will fail when creating some symlinks

termux_step_post_configure() {
	sed -i '/^LN_S/s/s/sfvn/' */Makefile
}

termux_step_make_install() {
	make pkgconfigdir=$TERMUX_PREFIX/lib/pkgconfig install
}
