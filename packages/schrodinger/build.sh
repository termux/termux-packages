TERMUX_PKG_HOMEPAGE=http://schrodinger.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Portable implementation of Dirac"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0, MPL-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING.GPL, COPYING.LGPL, 
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/schrodinger/files/schrodinger/${TERMUX_PKG_VERSION}/schroedinger-${TERMUX_PKG_VERSION}.tar.gz/download
TERMUX_PKG_SHA256=1decf7c5f54eafa3944e8ca4e3fd34cb8ae4a648
TERMUX_PKG_DEPENDS="x11-repo, gtk-doc, liboil"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--build=aarch64-unknown-linux-gnu"
