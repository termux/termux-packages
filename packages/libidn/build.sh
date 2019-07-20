TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libidn/
TERMUX_PKG_DESCRIPTION="GNU Libidn library, implementation of IETF IDN specifications"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=1.35
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=f11af1005b46b7b15d057d7f107315a1ad46935c7fcdf243c16e46ec14f0fe1e
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/libidn/libidn-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libiconv"
TERMUX_PKG_BREAKS="libidn-dev"
TERMUX_PKG_REPLACES="libidn-dev"

# Remove the idn tool for now, add it as subpackage if desired::
TERMUX_PKG_RM_AFTER_INSTALL="bin/idn share/man/man1/idn.1 share/emacs"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ld-version-script"
