TERMUX_PKG_HOMEPAGE=https://github.com/hyperrealm/libconfig
TERMUX_PKG_DESCRIPTION="C/C++ Configuration File Library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/hyperrealm/libconfig/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f67ac44099916ae260a6c9e290a90809e7d782d96cdd462cac656ebc5b685726

termux_step_pre_configure() {
	autoreconf -fi
}
