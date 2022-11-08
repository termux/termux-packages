TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/iso-codes-team/iso-codes
TERMUX_PKG_DESCRIPTION="Lists of the country, language, and currency names"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.12.0
TERMUX_PKG_SRCURL=https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${TERMUX_PKG_VERSION}/iso-codes-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ead53ac6cb000a726350eda10381b2339e7bed0680924d761d63f28f32da94b5
TERMUX_PKG_PLATFORM_INDEPENDENT=true

#If you install ISO codes over a previous installed version, the install step will fail when creating some symlinks

termux_step_post_configure() {
	sed -i '/^LN_S/s/s/sfvn/' */Makefile
}
