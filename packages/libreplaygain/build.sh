TERMUX_PKG_HOMEPAGE=https://www.musepack.net/
TERMUX_PKG_DESCRIPTION="Library to implement ReplayGain standard for audio"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE=LGPL
TERMUX_PKG_VERSION=475
TERMUX_PKG_SRCURL=https://files.musepack.net/source/libreplaygain_r${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8258bf785547ac2cda43bb195e07522f0a3682f55abe97753c974609ec232482
termux_step_pre_configure() { 
	cd ${TERMUX_PKG_SRCDIR} && autoreconf -vif
}
