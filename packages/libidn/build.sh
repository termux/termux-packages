TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libidn/
TERMUX_PKG_DESCRIPTION="GNU Libidn library, implementation of IETF IDN specifications"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.36
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libidn/libidn-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=14b67108344d81ba844631640df77c9071d9fb0659b080326ff5424e86b14038
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BREAKS="libidn-dev"
TERMUX_PKG_REPLACES="libidn-dev"

# Remove the idn tool for now, add it as subpackage if desired::
TERMUX_PKG_RM_AFTER_INSTALL="bin/idn share/man/man1/idn.1 share/emacs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ld-version-script"
