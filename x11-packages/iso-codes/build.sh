TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/iso-codes-team/iso-codes
TERMUX_PKG_DESCRIPTION="Lists of the country, language, and currency names"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.15.0
TERMUX_PKG_SRCURL=https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${TERMUX_PKG_VERSION}/iso-codes-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b83b54b9d7dd6eb877380b3ec46f370b05daf2cbfa131c612f03598d654c0ef8
TERMUX_PKG_PLATFORM_INDEPENDENT=true

#If you install ISO codes over a previous installed version, the install step will fail when creating some symlinks

termux_step_post_configure() {
	sed -i '/^LN_S/s/s/sfvn/' */Makefile
}
