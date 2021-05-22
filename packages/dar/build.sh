TERMUX_PKG_HOMEPAGE=http://dar.linux.free.fr/
TERMUX_PKG_DESCRIPTION="A full featured command-line backup tool, short for Disk ARchive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/dar/dar/${TERMUX_PKG_VERSION}/dar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=76dade8adbeb817ffc78bf592c8200487ab5650234cf539539a9cbc5d346beef
TERMUX_PKG_DEPENDS="attr, libbz2, libgcrypt, liblzma, liblzo, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH_BITS" = "32" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mode=32"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-mode=64"
	fi
	CXXFLAGS+=" $CPPFLAGS"
}
